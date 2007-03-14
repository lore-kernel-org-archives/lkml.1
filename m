Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXCNLoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXCNLoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXCNLoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:44:15 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59064 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161140AbXCNLoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:44:14 -0400
Date: Wed, 14 Mar 2007 12:44:17 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Florian Lohoff <flo@rfc822.org>
Subject: Re: [6/6] 2.6.21-rc3: known regressions
Message-ID: <20070314114417.GB18731@stusta.de>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313125025.GW18731@stusta.de> <1173818777.13341.128.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1173818777.13341.128.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 09:46:17PM +0100, Thomas Gleixner wrote:
> On Tue, 2007-03-13 at 13:50 +0100, Adrian Bunk wrote:
> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way
> > possibly involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > Subject    : Clocksource tsc unstable (delta = -154983451 ns)
> > References : http://lkml.org/lkml/2007/3/9/271
> > Submitter  : Jiri Slaby <jirislaby@gmail.com>
> > Status     : unknown
> 
> That's not a regression. That's an informal message, when the TSC
> watchdog detects that the TSC is unreliable. 

Looking at [1], there's also be a probably related "doesn't boot" 
problem.
My first guess would be commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
"clocksource init adjustments (fix bug #7426)".

Jiri, is the message also present with 2.6.21-rc2 (at a different place 
of the dmesg) for you?

> 	tglx

cu
Adrian

[1] http://lkml.org/lkml/2007/3/13/219

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

