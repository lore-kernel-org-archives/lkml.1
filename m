Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBVOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBVOYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZBVOYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:24:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41183 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZBVOYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:24:03 -0500
Date: Sun, 22 Feb 2009 14:23:45 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Cyril Hrubi? <metan@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, thommycheck@gmail.com,
       milan@ucw.cz
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
Message-ID: <20090222142345.GA21948@flint.arm.linux.org.uk>
References: <20090128113809.GA29424@elf.ucw.cz> <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com> <20090222135651.GD1387@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222135651.GD1387@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 02:56:51PM +0100, Pavel Machek wrote:
> On Thu 2009-02-12 22:22:37, Cyril Hrubi? wrote:
> > Hi,
> > 2.6.29-rc4 boots on spitz and looks overall good but framebuffer
> > redraws some lines terribly slow. When I'm editing text in bash from
> > the middle in some cases I can see redrawing the text pixel by pixel.
> > And suspend to ram on pressing On/Off button does nothing now (some
> > missing config option?).
> 
> Hmm, it gets worse: echo mem > /sys/power/state sleeps 2.6.28, but
> there's no way to resume it.

Sounds like the on/off button isn't configured as a wakeup source.
Without knowing anything about the platform (iow, where the on/off
button is connected) it's hard to tell what could be the problem.

Has the on/off button ever worked?

> About hda timeouts... I remember seeing them under older kernels, too,
> under loads such as kernel compile... plus keypresses tend to get lost
> under high loads :-(.

Really, what we need is for someone to step up to take on sorting out
Zaurus.  Looking at this thread, it seems there's very few people here
willing.  Also, I think Richard Purdie has moved on from Zaurus stuff.

I know there are a small number of people on linux-arm-kernel who have
access to some Zaurus platforms, but I don't know what they are.  Really,
you should be posting to that list if you seriously want help, because
I doubt they're subscribed to LKML.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
