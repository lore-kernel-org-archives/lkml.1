Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbYFSPFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbYFSPFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbYFSPFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:05:45 -0400
Received: from mail.macqel.be ([194.78.208.39]:4484 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYFSPFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:05:44 -0400
Date: Thu, 19 Jun 2008 17:05:37 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia ide kingston compactflash's have a new manufacturer
	id
Message-ID: <20080619150537.GA19698@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

Up to now, Kingston compactflash cards (ab)used the Toshiba Manufacturer's ID,
In their new CF cards, they use a new one.  Let's the ide subsystem
recognize CF cards with the new id.

Signed-off-by: Christophe Niclaes <cniclaes@develtech.com>
Acked-by: Philippe De Muyter <phdm@macqel.be>

diff -r 60ebd5153c48 drivers/ide/legacy/ide-cs.c
--- a/drivers/ide/legacy/ide-cs.c	Wed Jun 18 22:12:50 2008 -0700
+++ b/drivers/ide/legacy/ide-cs.c	Thu Jun 19 16:35:29 2008 +0200
@@ -410,6 +410,7 @@ static struct pcmcia_device_id ide_ids[]
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
 	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x004f, 0x0000),	/* Kingston */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
