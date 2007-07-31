Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbXGaWKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbXGaWKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXGaWKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:10:05 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3622 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbXGaWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:10:03 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 75] drivers/macintosh/therm_adt746x.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:10:03 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010010.03964.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/macintosh/therm_adt746x.c | 17298 -> 17244 (-54 bytes)

 drivers/macintosh/therm_adt746x.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/macintosh/therm_adt746x.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/macintosh/therm_adt746x.c	2007-07-31 11:18:55.000000000 +0200
@@ -379,13 +379,10 @@ static int attach_one_thermostat(struct
 	if (thermostat)
 		return 0;

-	th = (struct thermostat *)
-		kmalloc(sizeof(struct thermostat), GFP_KERNEL);
-
+	th = kzalloc(sizeof(struct thermostat), GFP_KERNEL);
 	if (!th)
 		return -ENOMEM;

-	memset(th, 0, sizeof(*th));
 	th->clt.addr = addr;
 	th->clt.adapter = adapter;
 	th->clt.driver = &thermostat_driver;
