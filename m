Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbZAXN04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbZAXN04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 08:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZAXN0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 08:26:37 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:39390 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbZAXN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 08:26:36 -0500
Date: Sat, 24 Jan 2009 14:26:32 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Risto Suominen <risto.suominen@gmail.com>
cc: adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
In-Reply-To: <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901241425310.13803@anakin>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
 <Pine.LNX.4.64.0901240951110.13803@anakin> <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Risto Suominen wrote:
> 2009/1/24 Geert Uytterhoeven <geert@linux-m68k.org>:
> > On Fri, 23 Jan 2009, Risto Suominen wrote:
> >> Xserver Xfbdev (kdrive) uses linux framebuffer in graphics mode. It doesn't
> >> need the text mode cursor, it's a bit annoying to have it there sitting in a
> >> corner. This patch disables the cursor even when in graphics mode.
> >>
> >> Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
> >> ---
> >> The testing is done on kernel version 2.6.18.
> >
> > Which is well... quite old.
> >
> > Does it also (still) happen with 2.6.28?
> >
> Well, I don't really know, but I assume it will: fbcon_is_inactive()
> still returns true if vc->vc_mode != KD_TEXT, and thus hinders
> fbcon_cursor() from doing anything in graphics mode.

FYI, I've just seen the other patch you posted before.
I'm also wondering what's really going wrong, as I haven't ever noticed this
problem during the last 10 years.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
