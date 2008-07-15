Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYGSDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYGSDOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 23:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYGSDOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 23:14:05 -0400
Received: from france.micfo.com ([92.48.68.3]:48035 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYGSDOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 23:14:04 -0400
X-Greylist: delayed 31744 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 23:14:04 EDT
From: Alberto Gonzalez <info@gnebu.es>
To: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: From 2.4 to 2.6 to 2.7?
Date: Tue, 15 Jul 2008 15:18:58 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org> <1216125715.10312.4.camel@localhost>
In-Reply-To: <1216125715.10312.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151518.59338.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008, Kasper Sandberg wrote:
> I like the current numbering fine.. my suggestion is to keep the current
> model, there are various reasons
>
> 1: it requires no effort
> 2: various things doesent break
> 3: naming isnt _THAT_ important

Sorry for entering a discussion from a project I'm just a user of, but I was 
thinking... I do see smallish problems with current scheme:

- First two numbers never change (2.6), so they're mostly useless.
- Third number gets too big (currently 26, and growing)
- Stable releases are already a fourth number (2.6.25.11. Unconfortable).

So a possible solution that would not break completely with historical numbers 
could be:

- Since you're aproaching 2.6.30 (around mid 2009), why not agree tu turn that 
into a 3.0 release? Peope have been expecting a version 3 of the kernel for a 
long time now... It might give the (false) impression that it's an all new 
release, but it would be explained that it's just a normal one. However, I 
also think that by that time, the last "problem" with Linux will be solved, 
i.e, the graphics thing. With the changes in DRM/DRI starting to appear in 
2.6.27 (maybe), they will stabilize through .28 and .29, making .30 a good 
release to declare the Linux kernel "completely mature", without any weak 
spot (so to say) and turn it into 3.0 release (the Free drivers for ATI and 
even NVIDIA will hopefully be mature by then too, as might be Gallium3D, 
VA-API, GEM/TTM, etc... )

- From there, how to proceed? Instead of making the same mistake again of 
having a useless middle number, each release would increment by a 10th. That 
is, instead of 3.0.1, 3.0.2, etc... just 3.1, 3.2, 3.3, etc... Then the stable 
releases would be 3.1.1, 3.1.2, etc... (no longer a 4 series of numbers). And 
after 3.9, we would have 4.0 to avoid having again a too bit number (3.26, 
etc...). Roughly, you release 5 kernels per year, so that would give enough 
time until you hit a high number (it will increment by one every two years). 
For example, it would take 20 years from 2009 until you hit version 13.0. 
Twenty years is a decent amount of time in kernel development. And well, even 
13 is not _that_ big anyway. You can push this numbering up to version 20 if 
necessary and that would give another 14 extra years. By then (year 2043) I'm 
sure that someone will have come up with a smart way of rearranging the 
numbering once more :-)

Regards.

