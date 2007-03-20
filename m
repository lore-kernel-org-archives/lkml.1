Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXCTOCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXCTOCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933230AbXCTOCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:02:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXCTOCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:02:18 -0400
From: Danny Kukawka <dkukawka@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] add Fujitsu Siemens Tablet PC devices to 8250_pnp.c
Date: Tue, 20 Mar 2007 15:01:41 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703201501.42209.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

adds device ids of two Fujitsu Siemens Tablet PCs to pnp_dev_table

Signed-off-by: Danny Kukawka <dkukawka@suse.de>

--- linux-2.6.21-rc4/drivers/serial/8250_pnp.c	2007-03-19 21:42:43.000000000 +0100
+++ linux-2.6.21-rc5/drivers/serial/8250_pnp.c	2007-03-19 21:55:53.000000000 +0100
@@ -340,6 +340,9 @@ static const struct pnp_device_id pnp_de
 	{       "FUJ02B8",              0 },
 	{       "FUJ02B9",              0 },
 	{       "FUJ02BC",              0 },
+	/* Fujitsu Wacom Tablet PC devices */
+	{	"FUJ02E5",		0	},
+	{	"FUJ02E6",		0	},
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
 	/* Unkown PnP modems */
