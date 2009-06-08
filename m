Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZFHHWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZFHHWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZFHHW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:22:27 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45553 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZFHHW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=D2Ey4G/MiKA+SgP1fXpCIcXKzGCGEmNRGlpb3VbVeqypYI8SqhF3NNVVsMPjuXbTKw
         RezJHb1wxWdmbrx5i7/v3yBgbWr8y+eORcU3tFmpb2m7y/i1mywfYRrV9M+Cqic7iqwi
         osN4NFKeyNsnSDFLPTi/6TWqBPelheUVodxPY=
Message-ID: <4A2CBA46.2020807@gmail.com>
Date: Mon, 08 Jun 2009 12:44:14 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Final Test of Email Client
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: D Pranith Kumar <bobby.prani@gmail.com>

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index ce04218..5e8bd94 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2045,6 +2045,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 	struct zsKeyInfo keyInfo;
 	struct usbdrv_private *macp = dev->ml_priv;
 	u16_t vapId = 0;
+   int ii;
 
 	/* zmw_get_wlan_dev(dev); */
 
@@ -2168,7 +2169,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		/* DUMP key context */
 		/* #ifdef WPA_DEBUG */
 		if (keyInfo.keyLength > 0) {
-			int ii;
 			printk(KERN_WARNING
 						"Otus: Key Context:\n");
 			for (ii = 0; ii < keyInfo.keyLength; ) {
@@ -2266,7 +2266,6 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		/* zfiWlanSetWpaIe(dev, zdparm->u.generic_elem.data,
 		* zdparm->u.generic_elem.len);
 		*/
-		int ii;
 		u8_t len = zdparm->u.generic_elem.len;
 		u8_t *wpaie = (u8_t *)zdparm->u.generic_elem.data;
 
@@ -2401,7 +2400,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct athr_wlan_param zdparm;
 	struct usbdrv_private *macp = dev->ml_priv;
 
-	int err = 0;
+	int err = 0, val = 0;
 	int changed = 0;
 
 	/* regp = macp->regp; */
@@ -2445,7 +2444,7 @@ int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			err = -EPERM;
 			break;
 		}
-		int val = *((int *) wrq->u.name);
+       val = *((int *) wrq->u.name);
 		if ((val < 0) || (val > 2)) {
 			err = -EINVAL;
 			break;
