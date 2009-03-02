Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbZCJQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbZCJQtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZCJQnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:55 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34623 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbZCJQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:41 -0400
Message-Id: <c9e8ec654db2ee34fc9fda29222aee9dd085ddaa.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:41:51 +0000
Subject: [PATCH 22/31] i2c: Auto-load i2c_dev module when device opened.
To: linux-kernel@vger.kernel.org
Cc: khali@linux-fr.org, linux-i2c@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_dev module is missing the char-major-89-* alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/i2c/i2c-dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 7e13d2d..f3f83ba 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -618,6 +618,7 @@ MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 		"Simon G. Vogl <simon@tk.uni-linz.ac.at>");
 MODULE_DESCRIPTION("I2C /dev entries driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(I2C_MAJOR);
 
 module_init(i2c_dev_init);
 module_exit(i2c_dev_exit);
-- 
1.6.0.5

