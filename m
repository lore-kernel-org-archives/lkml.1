Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJTUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJTUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYJTUJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:09:14 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48988 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYJTUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:09:13 -0400
Date: Mon, 20 Oct 2008 22:09:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: discarded `.exit.text' debugging?
Message-ID: <Pine.LNX.4.64.0810202207140.23258@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last night I got these in my build logs:

| `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
| `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

i.e. not much context. Is there an easy way to find out who's the
offender?

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
