Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZKGWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZKGWEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZKGWEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:04:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47312 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920AbZKGWEn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:04:43 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-pcmcia@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 22:04:45 +0000
Message-ID: <1257631485.15927.479.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 59/75] serial-cs: declare MODULE_FIRMWARE
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/serial/serial_cs.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index f02d1a9..df54e96 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -861,6 +861,18 @@ static struct pcmcia_device_id serial_ids[] = {
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, serial_ids);
+MODULE_FIRMWARE("cis/PCMLM28.cis");
+MODULE_FIRMWARE("cis/DP83903.cis");
+MODULE_FIRMWARE("cis/3CCFEM556.cis");
+MODULE_FIRMWARE("cis/3CXEM556.cis");
+MODULE_FIRMWARE("cis/SW_8xx_SER.cis");
+MODULE_FIRMWARE("cis/SW_7xx_SER.cis");
+MODULE_FIRMWARE("cis/SW_555_SER.cis");
+MODULE_FIRMWARE("cis/MT5634ZLX.cis");
+MODULE_FIRMWARE("cis/COMpad2.cis");
+MODULE_FIRMWARE("cis/COMpad4.cis");
+MODULE_FIRMWARE("cis/RS-COM-2P.cis");
+MODULE_FIRMWARE("GLOBETROTTER.cis");
 
 static struct pcmcia_driver serial_cs_driver = {
 	.owner		= THIS_MODULE,
-- 
1.6.5.2



