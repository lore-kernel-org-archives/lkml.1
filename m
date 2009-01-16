Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbZAPU7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbZAPU7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbZAPU7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:59:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738AbZAPU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:59:21 -0500
Date: Fri, 16 Jan 2009 12:58:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.29-rc2
Message-ID: <alpine.LFD.2.00.0901161244310.4965@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's out there now, or at least in the process of mirroring out.

About half of the bulk is a late MIPS merge (tssk, tssk, but I really 
couldn't make myself care too much), and there are a few odd new drivers 
there too. In fact, of the non-MIPS code, drivers is about half of the 
remaining one, and then firmware (which is really drivers too but shows up 
separately) is half of _that_ remaining half.

And there's the system call sign-extension for for the architectures that 
need it (ppc/64 and s390/64). The rest is really pretty small.

But despite being small, that's probably more important and noticeable to 
most people: the first slew of regression fixes. We had non-working 3D 
acceleration on many machines (no compiz! What shall we do without those 
wobbly windows!) that should be fixed, and a ton of other irritating 
issues like that.

The fixes are usually not all that big, but -rc1 really wasn't very good. 
Admittedly it wasn't really expected to, with the whole holidays thing.

So hopefully -rc2 is back to "normal -rc1 quality", and perhaps better. 
And since I'm leaving for LCA, it had better be better - I've done this 
release with the laptop I'm taking with me, just to check that I have all 
the pieces ready to fix up anything while at LCA, but I am not planning on 
being very active. And I know I'm not the only one there.

I'm not sure exactly what the limit for the kernel mailing list email size 
is, but I _think_ the shortlog should fit, at just over 32kB. It's short 
enough that people can read it an see what kind of silly small buglets got 
fixed, but I'll send it as a follow-up to this email in case it's big 
enough to trigger list limits for people.

			Linus
