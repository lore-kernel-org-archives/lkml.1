Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYJZSf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYJZSf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYJZSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:35:18 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:52201 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYJZSfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:35:16 -0400
Date: Sun, 26 Oct 2008 19:35:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Wolfgang Grandegger <wg@grandegger.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: w83781d doesn't link when built-in
In-Reply-To: <20081026163624.622a0931@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0810261934140.15317@anakin>
References: <Pine.LNX.4.64.0810261519410.15317@anakin>
 <20081026163624.622a0931@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Jean Delvare wrote:
> On Sun, 26 Oct 2008 15:20:26 +0100 (CET), Geert Uytterhoeven wrote:
> > When w83781d is built-in, the final links fails with the following vague error
> > message:
> > 
> > `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined
> > in discarded section `.exit.text' of drivers/built-in.o
> > 
> > w83781d_isa_unregister() cannot be marked __exit, as it's also called from
> > sensors_w83781d_init(), which is marked __init.
> 
> Good catch, thanks for reporting. For some reason the link doesn't fail
> here.

Probably w83781d_isa_unregister() got inlined?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
