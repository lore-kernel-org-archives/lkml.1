Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605Ab0ARRQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0ARRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565Ab0ARRQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:54 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0ARRQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sYU+G5gC1EIo/AfRVVbVYKa7Nrdpcah43j49/RkEEGeIehY1BQ8uqsW3FQ+93dxZlE
         PKzlSCYsX6cH3xPQTZeHTRYLaQZMK/8qw/tNDgjtIPb1cBtCB7S9GNscoZVVISdNz7bR
         8iNwkx4ry2ub3QhJd9NS6OMZSltxOW79xzMcM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:38 +0100
Message-Id: <20100118171538.14623.27441.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 13/64] pata_cs5535: use correct values for PIO1 and PIO2 data timings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: use correct values for PIO1 and PIO2 data timings

There shouldn't be any problems with it as IDE cs5535 host driver
has been using those values for years and they match values given
in the (publicly available) datasheet.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -98,7 +98,7 @@ static int cs5535_cable_detect(struct at
 static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u16 pio_timings[5] = {
-		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
+		0xF7F4, 0xF173, 0x8141, 0x5131, 0x1131
 	};
 	static const u16 pio_cmd_timings[5] = {
 		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
