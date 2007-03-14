Return-Path: <linux-kernel-owner+w=401wt.eu-S1422645AbXCNPPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422645AbXCNPPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422649AbXCNPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:15:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1749 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422645AbXCNPPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:15:13 -0400
Date: Wed, 14 Mar 2007 08:41:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070314084155.GA3993@ucw.cz>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr> <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >I think the sound example to the right really shows it. 
> >/dev/dsp has a
> >consistent ABI on a ton of systems. The API below it, 
> >varies. Linux got
> >file_operations and ALSA. Solaris/BSD may have its
> >vnode-and-so-on-functions and some sort of OSS.
> 
> I think this is a poor example as applications lose a 
> lot of
> functionality (multiple stream mixing, software volume 
> control, etc)
> by going through the legacy /dev/dsp interface vs. using 
> native ALSA.

OTOH /dev/dsp is nice, clean, unixy interface, while alsa creates ugly
ABI you should not even use unless you are libalsa. ouch.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
