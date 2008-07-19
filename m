Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYGSMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYGSMGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYGSMG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:06:27 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:30684 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYGSMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Y4yqi2CmQ9eWScgWTxlzVnNPxo6E8Lv7t5iozj9q/qwL0+R4/P+6QpvH4ztutLVM/Q
         PHb06ONLSfQznuftESYXlugYSGYGhlf3lZE+6jO03Na9OmjTouRNkcdCW0Djig26tIDq
         VnYc+ebSZC83LvqI/LLNYucSa0dw2mgB6viYo=
Message-ID: <ea11fea30807190506v242518afs45f7afbe4f41604b@mail.gmail.com>
Date: Sat, 19 Jul 2008 17:36:23 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, bezaur@gmail.com
Subject: [PATCH] Fix 'unused variable val1' warning in drivers/hwmon/w83791d.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below patch fixes the following warning :

drivers/hwmon/w83791d.c:1049: warning: unused variable 'val1'


Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 drivers/hwmon/w83791d.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index e4e91c9..0afecea 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1046,9 +1046,10 @@ static int w83791d_probe(struct i2c_client *client,
 {
 	struct w83791d_data *data;
 	struct device *dev = &client->dev;
-	int i, val1, err;
+	int i, err;

 #ifdef DEBUG
+	int val1;
 	val1 = w83791d_read(client, W83791D_REG_DID_VID4);
 	dev_dbg(dev, "Device ID version: %d.%d (0x%02x)\n",
 			(val1 >> 5) & 0x07, (val1 >> 1) & 0x0f, val1);
-- 
1.5.4.3




Thanks -
Manish
