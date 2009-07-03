Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZGCNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZGCNNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbZGCNNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:13:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:33144 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZGCNNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,342,1243839600"; 
   d="scan'208,223";a="161286000"
Date: Fri, 3 Jul 2009 21:08:03 +0800
From: Alek Du <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: pca953x: Add support for MAX7315
Message-ID: <20090703210803.24927aa2@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From eb473218a66568ee99d6be3904a0b95d67d0016e Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Wed, 1 Jul 2009 12:36:49 +0800
Subject: [PATCH] gpio: pca953x: Add support for MAX7315

MAX7315 is pin and software compatible with PCA9534, so add it to
the I2C device ID table of pca953x driver.
http://www.datasheetcatalog.org/datasheet/maxim/MAX7315.pdf

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
---
 drivers/gpio/pca953x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index cdb6574..8ab1308 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -40,6 +40,7 @@ static const struct i2c_device_id pca953x_id[] = {
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
+	{ "max7315", 8, },
 	{ "pca6107", 8, },
 	{ "tca6408", 8, },
 	{ "tca6416", 16, },
-- 
1.6.0.4
