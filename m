Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbXLPXYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbXLPXYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbXLPXX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:23:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43745 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759179AbXLPXXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:23:55 -0500
Date: Mon, 17 Dec 2007 00:23:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071216232353.GC5692@elf.ucw.cz>
References: <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <20071215230036.GF2434@elf.ucw.cz> <47645D66.4020506@zytor.com> <20071216094029.GD27280@elte.hu> <47659BF3.4040100@zytor.com> <4765AF78.60307@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765AF78.60307@reed.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The process of safely making delicate changes here is beyond my 
> responsibility as just a user - believe me, I'm not suggesting that a risky 
> fix be put in .24.   I can patch my own kernels, and I can even share an 
> unofficial patch with others for now, or suggest that Fedora and Ubuntu add 
> it to their downstream.
>
> May I make a small suggestion, though.   If the decision is a DMI-keyed 
> switch from out-80 to udelay(2)  gets put in, perhaps there should also be 
> a way for people to test their own configuration for the underlying problem 
> made available as a script.   Though it is a "hack", all you need to freeze 
> a problem system is to run a loop doing about 1000 "cat /dev/nvram > 
> /dev/null"  commands.  If that leads to a freeze, one might ask to have the 
> motherboard added to the DMI-key list.

Can you freeze it by catting /dev/rtc, too? That may be significant,
because that is readable for group audio (at least on some
systems)... which would smell like "small security hole" to me.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
