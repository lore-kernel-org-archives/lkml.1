Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbZAOMoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbZAOMoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZAOMoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:44:04 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:19020 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAOMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:44:03 -0500
Date: Thu, 15 Jan 2009 13:43:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Balaji Rao <balajirrao@openmoko.org>, Samuel Ortiz <sameo@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd/pcf50633: Terminate i2c_device_id list
Message-ID: <20090115134347.45a88999@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_device_id list is supposed to be zero-terminated.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
---
As a side note, I am currious why you set the driver_data to 0x73 and
then never use it...

 drivers/mfd/pcf50633-core.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.29-rc1.orig/drivers/mfd/pcf50633-core.c	2009-01-15 11:45:36.000000000 +0100
+++ linux-2.6.29-rc1/drivers/mfd/pcf50633-core.c	2009-01-15 13:31:22.000000000 +0100
@@ -678,6 +678,7 @@ static int __devexit pcf50633_remove(str
 
 static struct i2c_device_id pcf50633_id_table[] = {
 	{"pcf50633", 0x73},
+	{/* end of list */}
 };
 
 static struct i2c_driver pcf50633_driver = {


-- 
Jean Delvare
