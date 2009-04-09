Return-Path: <linux-kernel-owner+w=401wt.eu-S936922AbZDIW6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936922AbZDIW6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZDIW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:58:25 -0400
Received: from mx0.towertech.it ([213.215.222.73]:40559 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936951AbZDIW6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:58:24 -0400
Date: Fri, 10 Apr 2009 00:58:20 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Message-ID: <20090410005820.4fcfcc1f@i1501.lan.towertech.it>
In-Reply-To: <20090409153921.04b6384c.akpm@linux-foundation.org>
References: <1239036633-10032-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090409153921.04b6384c.akpm@linux-foundation.org>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 15:39:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > The rtc_update_irq() might be called with irqs enabled, if a interrupt
> > handler was registered without IRQF_DISABLED.  
> 
> Why?  What are the consequences of not merging the patch?  Is it a
> bugfix?  If so, what are the user-visible effects of the bug?

 rtc_update_irq() is called by a driver, and a driver
 is supposed to know when it's doing the call.

 The driver can either use IRQF_DISABLED or disable the
 interrupts in some other ways. 

 I also suspect this is some legacy we are carrying on, 
 so it's better to leave the decision on the interrupt
 handling to the driver itself.

 Unless I'm missing something.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

