Return-Path: <linux-kernel-owner+w=401wt.eu-S1761963AbYF3RJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761963AbYF3RJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYF3RJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:09:12 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:36359 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYF3RJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:09:11 -0400
Date: Mon, 30 Jun 2008 19:09:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: JosephChan@via.com.tw
cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/13] viafb: viafb.modes, viafb.txt
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7705@exchtp03.taipei.via.com.tw>
Message-ID: <Pine.LNX.4.64.0806301902390.26408@anakin>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7705@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, JosephChan@via.com.tw wrote:
> +[Bootup with viafb]:
> +--------------------
> +    Add the following line to your grub.conf:
> +    append = "video=viafb:viafb_mode=1024x768,via_fb_bpp=32,viafb_refresh=85"

Why not support simply video=1024x768-32@85 (or
video=viafb:1024x768-32@85, if you have other video cards too), as can be
parsed by fb_find_mode()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
