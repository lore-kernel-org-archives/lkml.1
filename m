Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbXCOJLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbXCOJLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXCOJLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:11:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51285 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752328AbXCOJLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:11:07 -0400
Date: Thu, 15 Mar 2007 10:10:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jaroslav Kysela <perex@suse.cz>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070315091048.GA17886@elf.ucw.cz>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr> <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com> <20070314084155.GA3993@ucw.cz> <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz> <20070315090330.GF16330@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315090330.GF16330@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So... in dsp, if I wanted to record sound, I did
> 
> 	cat /dev/dsp > /tmp/foo; cat /tmp/foo > /dev/dsp
> 
> If that worked, I had usable sound system, and if it broke, I knew it
> is kernel fault. 
> 
> With alsa it is
> 
> 	download & install alsalib
> 	download & install alsautils
> 	create 1007 nodes in /dev
> 	launch alsamixer, figure out what to do from inadequate descriptions
> 	launch arecord, try to guess some suitable options
> 	launch aplay, try to guess some options
> 
> ...if it does not work, it may be a kernel problem or userspace
> problem; I'm left with debugging both. That makes alsa pretty much
> untestable.

(Just for the record, I should note that networking is misdesigned in
similar way; that's why we have eth0 instead of /dev/eth0, and need
special tools to rename network interface. But this mistake dates to
BSD days or something, so we got used to it... and at least you do not
need to keep libnetwork up to date to keep your  net devices working.

So networking provides _ugly_ hardware abstraction, but it provides
it).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
