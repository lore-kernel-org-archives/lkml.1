Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYATLIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYATLIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 06:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYATLIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 06:08:15 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:59938 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYATLIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 06:08:14 -0500
Date: Sun, 20 Jan 2008 12:08:11 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: devzero@web.de
cc: mj@ucw.cz,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: "problem" with mdacon
In-Reply-To: <112492815@web.de>
Message-ID: <Pine.LNX.4.64.0801201205050.28200@anakin>
References: <112492815@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Roland,

On Fri, 18 Jan 2008, devzero@web.de wrote:
> sorry for contacting directly, but i was unsure about what list is best to ask questions for console specific stuff.
> maybe  linux-fbdev or linuxconsole-dev ? the latter looks dead - there is nothing but spam in the recent archive...

I'd use linux-fbdev-devel and cc to lkml (already added).

> ok - my "problem" (not being a real one, but not sure if this is a bug)
> 
> if i do "modprobe mdacon" (without any options) the system console output freezes and takes no more keyboard input (no vt switching, too)
> this happens on any real hardware and also in vmware.
> 
> looks weird to me - is this expected behaviour ?
> 
> i would have expected some "no such device or adress".
> 
> found this by chance by some module load/unload stresstesting and there are not many modules which break my system when loading/unloading - mdacon is one of the very few...
> 
> would be nice to get a comment about this.

I think it should just complain with `mdacon: MDA card not detected.',
if no MDA card is present.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
