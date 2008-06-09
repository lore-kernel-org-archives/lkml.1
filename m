Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYFIGoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYFIGoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYFIGog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:44:36 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:41161 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbYFIGof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:44:35 -0400
Date: Mon, 9 Jun 2008 08:44:33 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>, Peter De Schrijver <p2@debian.org>
cc: Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: could the Apollo support possibly work?
In-Reply-To: <20080608190513.GE4048@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0806090842490.25145@anakin>
References: <20080608190513.GE4048@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008, Adrian Bunk wrote:
> Nothing seems to set apollo_model (apollo_parse_bootinfo() has no caller).
> 
> Therefore trying to boot an Apollo machine seems to do:
>   arch/m68k/kernel/setup.c:setup_arch()
>     arch/m68k/apollo/config.c:config_apollo()
>       arch/m68k/apollo/config.c:dn_setup_model() 
>         panic()
> 
> Do I miss anything?

Obviously it should be called from m68k_parse_bootinfo(), but there's no
MACH_IS_APOLLO case there. Strange...

> Does anyone still have this hardware and tried booting it in recent years?
> 
> This problem already exists in kernel 2.4.0, and my gut feeling is 
> it's quite dead code I could remove.

P2?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
