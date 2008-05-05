Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYEET1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYEET1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbYEET1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:27:25 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:51714 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbYEET1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:27:23 -0400
Date: Mon, 5 May 2008 21:27:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: [PATCH 3/3] CONFIG_SCSI_MAC_ESP needs CONFIG_SCSI_SPI_ATTRS
In-Reply-To: <Pine.LNX.4.64.0805052118050.24098@anakin>
Message-ID: <Pine.LNX.4.64.0805052126200.28495@anakin>
References: <Pine.LNX.4.64.0805052118050.24098@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

The new mac_esp scsi driver needs CONFIG_SCSI_SPI_ATTRS, just like all other
drivers using the new esp_scsi core.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1679,6 +1679,7 @@ config MAC_SCSI
 config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
 	depends on MAC && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
 	  based Macintoshes.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
