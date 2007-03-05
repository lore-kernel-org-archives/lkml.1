Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbXCEXMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbXCEXMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXCEXMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:12:22 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50975 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752259AbXCEXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:12:20 -0500
Date: Tue, 6 Mar 2007 00:12:20 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Soeren Sonnenburg <kernel@nn7.de>, Daniel Walker <dwalker@mvista.com>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
Message-ID: <20070305231220.GP3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015040.GJ3441@stusta.de> <20070305075747.GA19838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070305075747.GA19838@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 08:57:47AM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Subject    : i386: no boot with nmi_watchdog=1  (clockevents)
> > References : http://lkml.org/lkml/2007/2/21/208
> > Submitter  : Daniel Walker <dwalker@mvista.com>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > Status     : problem is being debugged
> 
> FYI, this is not a "wont boot" problem, this should be a "NMI watchdog 
> does not work" problem - which has far lower severity. Also, Thomas did 
> a fix for this which is now in -mm.

Thanks for your corrections, it's now:

Subject    : i386: NMI watchdog does not work  (clockevents)
References : http://lkml.org/lkml/2007/2/21/208
Submitter  : Daniel Walker <dwalker@mvista.com>
Caused-By  : Thomas Gleixner <tglx@linutronix.de>
             commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Fixed-By   : Thomas Gleixner <tglx@linutronix.de>
Commit     : a5f5e43e2b1377392f9afe93aca29b9abf1d6a44
Status     : fixed in -rc3


> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

