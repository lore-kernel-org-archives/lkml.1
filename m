Return-Path: <linux-kernel-owner+w=401wt.eu-S1763667AbXGPO6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763667AbXGPO6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbXGPO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:58:37 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:45479 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758092AbXGPO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:58:37 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: linux-janitors@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] potential parse error, drivers/i2c/busses/i2c-pmcmsp.c
Date: Mon, 16 Jul 2007 16:57:02 +0200
Message-ID: <87r6n85rcx.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


potential parse error in initializer.


Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 

diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index 03188d2..17cecf1 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -630,7 +630,7 @@ static struct i2c_adapter pmcmsptwi_adap
 static struct platform_driver pmcmsptwi_driver = {
 	.probe  = pmcmsptwi_probe,
 	.remove	= __devexit_p(pmcmsptwi_remove),
-	.driver {
+	.driver = {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
 	},

