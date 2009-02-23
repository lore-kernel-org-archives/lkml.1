Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZBWPUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZBWPUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbZBWPT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:19:57 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:49247 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZBWPT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:19:56 -0500
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
From: Richard Purdie <rpurdie@rpsys.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Cyril Hrubi? <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, pavel.urban@ct.cz,
       thommycheck@gmail.com, milan@ucw.cz
In-Reply-To: <20090222142345.GA21948@flint.arm.linux.org.uk>
References: <20090128113809.GA29424@elf.ucw.cz>
	 <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com>
	 <20090222135651.GD1387@ucw.cz>
	 <20090222142345.GA21948@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 15:21:23 +0000
Message-Id: <1235402483.5386.39.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-22 at 14:23 +0000, Russell King wrote:
> On Sun, Feb 22, 2009 at 02:56:51PM +0100, Pavel Machek wrote:
> > On Thu 2009-02-12 22:22:37, Cyril Hrubi? wrote:
> > > Hi,
> > > 2.6.29-rc4 boots on spitz and looks overall good but framebuffer
> > > redraws some lines terribly slow. When I'm editing text in bash from
> > > the middle in some cases I can see redrawing the text pixel by pixel.
> > > And suspend to ram on pressing On/Off button does nothing now (some
> > > missing config option?).
> > 
> > Hmm, it gets worse: echo mem > /sys/power/state sleeps 2.6.28, but
> > there's no way to resume it.
> 
> Sounds like the on/off button isn't configured as a wakeup source.
> Without knowing anything about the platform (iow, where the on/off
> button is connected) it's hard to tell what could be the problem.

Its connected in through GPIO 0.

> Has the on/off button ever worked?

Yes, this always used to work fine for both suspending and resuming.

> > About hda timeouts... I remember seeing them under older kernels, too,
> > under loads such as kernel compile... plus keypresses tend to get lost
> > under high loads :-(.
> 
> Really, what we need is for someone to step up to take on sorting out
> Zaurus.  Looking at this thread, it seems there's very few people here
> willing.  Also, I think Richard Purdie has moved on from Zaurus stuff.

Its really a time problem. I couldn't keep up with the PXA architecture
changes and give enough time to review and test them all effectively and
things have slipped from there. I've tried to provide input where I can
but would certainly welcome any help. My new employer means I'll be
doing less ARM work in general too for some reason...

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

