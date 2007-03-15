Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbXCOJdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbXCOJdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXCOJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:33:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47945 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752741AbXCOJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:33:10 -0400
Date: Thu, 15 Mar 2007 10:32:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: Jaroslav Kysela <perex@suse.cz>, Lee Revell <rlrevell@joe-job.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070315093255.GH16330@elf.ucw.cz>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr> <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com> <20070314084155.GA3993@ucw.cz> <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz> <20070315090330.GF16330@elf.ucw.cz> <20070315091048.GA17886@elf.ucw.cz> <45F9107C.8090506@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F9107C.8090506@vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>	download & install alsalib
> >>	download & install alsautils
> >>	create 1007 nodes in /dev
> 
> I really hope you meant permission 1007 nodes, not 1007 nodes!  I'm 
> checking right now, and if the latter is the case, I'm going to 
> uninstall alsa, even if that means my computer will forever be silent, 
> it will be silent in protest.

I meant 1007 nodes... well, not literaly. For sound to work on my
system, I seem to need at least

crw-r--r--  1 root root 116,  0 Mar 24  2005 controlC0
crw-r--r--  1 root root 116, 32 Mar 24  2005 controlC1
crw-rw-rw-  1 root root 116,  4 Feb  1 16:33 hwC0D0
crw-r--r--  1 root root 116, 36 Mar 24  2005 hwC1D0
crw-rw-rw-  1 root root 116,  8 Feb  1 16:33 midiC0D0
crw-rw-rw-  1 root root 116, 24 Feb  1 16:33 pcmC0D0c
crw-rw-rw-  1 root root 116, 16 Feb  1 16:33 pcmC0D0p
crw-rw-rw-  1 root root 116, 48 Feb  1 16:34 pcmC1D0p
crw-rw-rw-  1 root root 116,  1 Feb  1 16:33 seq
crw-rw-rw-  1 root root 116, 33 Feb  1 16:33 timer

...fact that minor numbers are not allocated in Doc*/devices.txt does
not help, either.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
