Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYEETZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYEETZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYEETZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:25:06 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:33838 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYEETZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:25:04 -0400
Date: Mon, 5 May 2008 21:25:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] m68k mac_esp prerequisites and updates
Message-ID: <Pine.LNX.4.64.0805052118050.24098@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew

The new mac_esp SCSI driver already went in through the linux-scsi tree in

    commit 6fe07aaffbf086a0ce9134ef27ce4a8921ff5947
    Author: Finn Thain <fthain@telegraphics.com.au>
    Date:   Fri Apr 25 10:06:05 2008 -0500

    [SCSI] m68k: new mac_esp scsi driver
	    
    Replace the mac_esp driver with a new one based on the
    esp_scsi core.

Here are some more patches related to this driver:
  [1] [PATCH] m68k: Handle 68040 bus faults
  [2] [PATCH] m68k: remove old mac_esp cruft
  [3] [PATCH] CONFIG_SCSI_MAC_ESP needs CONFIG_SCSI_SPI_ATTRS

[1] is a prerequisite for the PDMA support in the mac_esp SCSI driver.
[2] and [3] are cleanups.

Please apply. Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
