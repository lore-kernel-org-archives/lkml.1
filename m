Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbZJSOqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbZJSOqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbZJSOqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:46:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57152 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756131AbZJSOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:46:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Mike Frysinger <vapier@gentoo.org>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Staticise __adp5520_ack_bits()
Date: Mon, 19 Oct 2009 15:46:22 +0100
Message-Id: <1255963582-6796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is not exported as the __ indicates. __

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/adp5520.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
index 401a9b6..b266447 100644
--- a/drivers/mfd/adp5520.c
+++ b/drivers/mfd/adp5520.c
@@ -66,7 +66,8 @@ static int __adp5520_write(struct i2c_client *client,
 	return 0;
 }
 
-int __adp5520_ack_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
+static int __adp5520_ack_bits(struct i2c_client *client, int reg,
+			      uint8_t bit_mask)
 {
 	struct adp5520_chip *chip = i2c_get_clientdata(client);
 	uint8_t reg_val;
-- 
1.6.5

