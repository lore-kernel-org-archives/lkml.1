Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbYHDHC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbYHDHC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbYHDHCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:02:46 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:53263 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbYHDHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:02:45 -0400
Date: Mon, 4 Aug 2008 09:02:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kbuild@vger.kernel.org
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>
Subject: `make oldconfig' no longer updating `.config.old'?
Message-ID: <Pine.LNX.4.64.0808040857340.23329@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

I have the habit of doing `make .config{.old,}' after each config run,
to see what was changed. But since a few weeks, `make oldconfig' no longer
seems to update `.config.old'.

This also breaks the default behavior of `scripts/diffconfig' (`If no
config files are specified, .config and .config.old are used.').

Was this change intentional?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
