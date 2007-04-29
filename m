Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXD2RF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXD2RF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXD2RF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:05:56 -0400
Received: from www.osadl.org ([213.239.205.134]:35551 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbXD2RFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:05:55 -0400
Subject: Re: [patch 5/9] IEEE1394: Spinlock initializer cleanup
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
In-Reply-To: <4634CB45.70408@s5r6.in-berlin.de>
References: <20070429154221.159165000@linutronix.de> >
	 <20070429154337.581254000@linutronix.de> >
	  <4634CB45.70408@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 19:08:02 +0200
Message-Id: <1177866482.5791.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 18:43 +0200, Stefan Richter wrote:
> Thomas Gleixner wrote:
> > --- linux-2.6.orig/drivers/ieee1394/ieee1394_transactions.c
> > +++ linux-2.6/drivers/ieee1394/ieee1394_transactions.c
> > @@ -32,7 +32,7 @@
> >  #ifndef HPSB_DEBUG_TLABELS
> >  static
> >  #endif
> > -spinlock_t hpsb_tlabel_lock = SPIN_LOCK_UNLOCKED;
> > +DEFINE_SPINLOCK(hpsb_tlabel_lock);
> 
> We've got already an identical patch from Milind Arun Choudhary,
> http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=commitdiff;h=ca79b9d41152ff8605ed5503fd4cbfe0ea60ee7f
> in linux1394-2.6.git/master and hence in -mm.  It'll be part of the post
> 2.6.21 pull request I'll send out RSN, unless your patch bypasses me
> somehow.

Missed that one.

Thanks,

	tglx


	

