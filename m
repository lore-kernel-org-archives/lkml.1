Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbXCNP7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbXCNP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXCNP7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:59:06 -0400
Received: from mail1.perex.cz ([212.20.107.53]:54911 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbXCNP7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:59:04 -0400
Date: Wed, 14 Mar 2007 16:59:00 +0100 (CET)
From: Jaroslav Kysela <perex@suse.cz>
X-X-Sender: perex@tm8103.perex-int.cz
To: Pavel Machek <pavel@ucw.cz>
cc: Lee Revell <rlrevell@joe-job.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070314084155.GA3993@ucw.cz>
Message-ID: <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz>
References: <20070309180230.GA17988@elte.hu>
 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
 <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr>
 <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com>
 <20070314084155.GA3993@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Pavel Machek wrote:

> Hi!
> 
> > >I think the sound example to the right really shows it. 
> > >/dev/dsp has a
> > >consistent ABI on a ton of systems. The API below it, 
> > >varies. Linux got
> > >file_operations and ALSA. Solaris/BSD may have its
> > >vnode-and-so-on-functions and some sort of OSS.
> > 
> > I think this is a poor example as applications lose a 
> > lot of
> > functionality (multiple stream mixing, software volume 
> > control, etc)
> > by going through the legacy /dev/dsp interface vs. using 
> > native ALSA.
> 
> OTOH /dev/dsp is nice, clean, unixy interface, while alsa creates ugly
> ABI you should not even use unless you are libalsa. ouch.

Pavel, calm down. World is not perfect and there are always probes to 
optimize things. We use standard file operations - open/close/ioctl/mmap, 
too.

						Jaroslav

-----
Jaroslav Kysela <perex@suse.cz>
Linux Kernel Sound Maintainer
ALSA Project, SUSE Labs
