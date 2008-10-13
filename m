Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYJMG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYJMG5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYJMG5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:57:05 -0400
Received: from yorgi.telenet-ops.be ([195.130.133.69]:53025 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYJMG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:57:04 -0400
Date: Mon, 13 Oct 2008 08:56:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Marek_Va=C5=A1ut?= <marek.vasut@gmail.com>
cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: ucb1400: static function in header file
Message-ID: <Pine.LNX.4.64.0810130854180.30249@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Compiling the ucb1400 driver gives me:

| include/linux/ucb1400.h:139: warning: 'ucb1400_adc_read' defined but not used

because ucb1400_adc_read is static, but not inline.
Please either make it inline, or move it out of the header file (it's
not that small).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
