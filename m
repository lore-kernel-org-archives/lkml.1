Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbYLWMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbYLWMyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYLWMyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:54:08 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:35422 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYLWMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:54:07 -0500
Date: Tue, 23 Dec 2008 13:54:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 3/4 v5] i.MX31: framebuffer driver
In-Reply-To: <Pine.LNX.4.64.0812221929300.5241@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812231352390.17497@anakin>
References: <Pine.LNX.4.64.0812221922200.5241@axis700.grange>
 <Pine.LNX.4.64.0812221929300.5241@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008, Guennadi Liakhovetski wrote:
> --- /dev/null
> +++ b/drivers/video/mx3fb.c
> @@ -0,0 +1,1853 @@

> +/**
> + * mx3fb_check_var() - check and adjust framebuffer variable parameters.
> + *
> + * @var:	framebuffer variable parameters
> + * @fbi:	framebuffer information pointer
> + */
> +static int mx3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *fbi)
> +{

    [...]

> +	/* Copy nonstd field to/from sync for fbset usage */
> +	var->sync |= var->nonstd;
> +	var->nonstd |= var->sync;

What's the purpose of this (ab)use of .nonstd?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
