Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXJ2M2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXJ2M2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXJ2M2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:28:19 -0400
Received: from mx0.towertech.it ([213.215.222.73]:60867 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752872AbXJ2M2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:28:18 -0400
Date: Mon, 29 Oct 2007 13:20:27 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
Subject: Re: BUG: lock held when returning to user space
Message-ID: <20071029132027.45b51ff8@i1501.lan.towertech.it>
In-Reply-To: <Pine.LNX.4.64.0710281211170.18815@twin.jikos.cz>
References: <472348F6.6050100@googlemail.com>
	<Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
	<1193498921.5648.68.camel@lappy>
	<20071027084646.434ccb4f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710281211170.18815@twin.jikos.cz>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 12:12:19 +0100 (CET)
Jiri Kosina <jikos@jikos.cz> wrote:

> On Sat, 27 Oct 2007, Andrew Morton wrote:
> 
> > It's a fairly daft thing to do.  I think it'd be saner to teach rtc about
> > test_and_set_bit() personally..  
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> RTC: convert mutex to bitfield
> 
> RTC code is using mutex to assure exclusive access to /dev/rtc.
> This is however wrong usage, as it leaves the mutex locked when
> returning into userspace, which is unacceptable.
> 
> Convert rtc->char_lock into bit operation.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

