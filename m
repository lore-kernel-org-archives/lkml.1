Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYJBWTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYJBWTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJBWTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:19:30 -0400
Received: from mx0.towertech.it ([213.215.222.73]:45325 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752235AbYJBWT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:19:29 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2008 18:19:29 EDT
Date: Fri, 3 Oct 2008 00:12:38 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, rtc-linux@googlegroups.com,
       stable@kernel.org
Subject: Re: [PATCH] rtc: fix kernel panic on second use of SIGIO
 nofitication
Message-ID: <20081003001238.7030c151@i1501.lan.towertech.it>
In-Reply-To: <20081002144941.18211dbb.akpm@linux-foundation.org>
References: <20080914181122.GA32250@joi>
	<20081002144941.18211dbb.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 14:49:41 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 14 Sep 2008 20:11:27 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > When user space uses SIGIO notification and forgets to disable it before
> > closing file descriptor, rtc->async_queue contains stale pointer to struct
> > file. When user space enables again SIGIO notification in different process,
> > kernel dereferences this (poisoned) pointer and crashes.
> > 
> > So disable SIGIO notification on close.
> > 
> 
> David, Alessandro: can we please have a review-n-ack of this one for
> 2.6.27 and earlier?  
> 
> Thanks.
> 
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> When userspace uses SIGIO notification and forgets to disable it before
> closing file descriptor, rtc->async_queue contains stale pointer to struct
> file.  When user space enables again SIGIO notification in different
> process, kernel dereferences this (poisoned) pointer and crashes.
> 
> So disable SIGIO notification on close.

 [...]
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

