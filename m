Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXHNV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXHNV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbXHNVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:22:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38404 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756305AbXHNVWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:48 -0400
Date: Tue, 14 Aug 2007 23:22:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drivers/acpi/scan.c:create_modalias() static
Message-ID: <20070814212235.GY18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global create_modalias() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
08005ed26370f24624bc7d88ced619318f4c0f56 
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index be74347..64620d6 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -35,8 +35,9 @@ struct acpi_device_bus_id{
  * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
  * char *modalias: "acpi:IBM0001:ACPI0001"
 */
-int create_modalias(struct acpi_device *acpi_dev, char *modalias, int size){
-
+static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
+			   int size)
+{
 	int len;
 
 	if (!acpi_dev->flags.hardware_id)

