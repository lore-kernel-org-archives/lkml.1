Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYKRA1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYKRA1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYKRA13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:27:29 -0500
Received: from twin.jikos.cz ([213.151.79.26]:52889 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbYKRA12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:27:28 -0500
Date: Tue, 18 Nov 2008 01:26:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.28-rc4-mmotm1110 shift-lock oddness
In-Reply-To: <20081117162350.82b2806b.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.1.10.0811180125150.3104@twin.jikos.cz>
References: <5397.1226959015@turing-police.cc.vt.edu> <20081117162350.82b2806b.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Andrew Morton wrote:

> > Twice today, I've managed to get my laptop into an odd state where the keyboard
> > got quite confused:
> > 
> > 1) For the characters [a-z] the shift bit was *inverted* - if the shift-lock
> > LED was off, you'd get UPPER-case, and if it was on, you'd get lower-case.
> > 
> > 2) To add to the fun, the 0-9 keys were stuck shifted - I'd get the special
> > characters no matter what setting the shift or shift-lock key had.  I suspect
> > that the special-char keys like [{ and ;: were also stuck in shifted state,
> > but can't totally confirm it.
> > 
> > The previous two issues combined meant that I wasn't able to su or login
> > as root to do much of anything about it (guess who has special chars in their
> > root password? ;)
> > 
> > 3) ctl-alt-Fn to switch virtual consoles was spotty/erratic - one time
> > I was unable to use it at all, another time I was able to use c-a-F1 to get
> > to a green-screen console, but then F2 to get another one or F7 to get
> > back to the X server screen wouldn't work.
> > 
> > 4) Fortunately for my sanity, alt-sysrq was still working as advertised,
> > so I was able to reboot and thus clear the problem.
> > 
> > I was thinking this might be a simple "missed a key press/released" event
> > for a shift key, except that doesn't explain the numerics getting stuck shifted.
> > 
> > Any suggestions/hints for instrumentation/etc, in case I can replicate it
> > again?
> That's the first such report I've seen.  Let's add some cc's.

First, we'd need a little bit more information about the hardware in 
question, I guess.

What laptop is that, please? Is the keyboard PS/2-connected or 
USB-connected? Could you obtain evtest output from the buggy cases please?

-- 
Jiri Kosina
