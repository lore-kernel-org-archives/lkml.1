Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXFNHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXFNHFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXFNHFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:05:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51010 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXFNHFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:05:40 -0400
Date: Thu, 14 Jun 2007 09:18:02 +0200
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
Message-ID: <20070614071802.GJ7266@flower.upol.cz>
References: <463698D5.20102@zytor.com> <alpine.LFD.0.98.0704301940320.3808@woody.linux-foundation.org> <4637A3F6.70508@gmail.com> <alpine.LFD.0.98.0705011433050.3808@woody.linux-foundation.org> <4637B6B5.5060502@zytor.com> <E1HyhJM-00045g-09@flower> <4670CDF0.808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4670CDF0.808@zytor.com>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 10:11:12PM -0700, H. Peter Anvin wrote:
> Oleg Verych wrote:
> > Thus, text mode on modern hardware isn't useable that much, only with
> > Terminus font it is kind of normal (kudos to Dimitar Toshkov Jekov).
> > But it's only option to unfortunately sucking X11, even with memory
> > bandwidth, you are talking about.
> 
> That's another reason to use the framebuffer console on laptops.

Last time i tried, it wasn't so much fun either. Mainly due to wild
cursor, that in normal text mode is well-behaved thing. Visually fb looks
much heavier. What's the benefit, if you see how windows in emacs are
painted? I don't know how giga-hertz/mem in cpu/sys-ram,
mega-hertz/ram in gpu are doing better job WRT to anything in visual
domain.

Also i don't know what to do in case of bugs/oops and "officially" closed
hardware specs on ATI chips{ref}.

About laptop. First and last time i ran new X11 (X.org) there, it drove
VGA fan really crazy. Don't know how it changed now, it was certainly due
to blindly switching 3D on. I don't want to remove *standard* drivers
because of that stupidness [see ref].

And after whole year being with Debian Sarge only, new application update
led me to just drop all that X stuff and run windoze (silently sold to me
with that laptop) if i need a stupid web browser with all that WEB 2.0
and Java crap...
____
