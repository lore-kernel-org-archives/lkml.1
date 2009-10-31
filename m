Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbZJaJmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbZJaJmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932479AbZJaJmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:42:02 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35835 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZJaJl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=DfBX3fehXvVJwl2TeyHRvPpoSCL+8ychLyjaEaq5I7DHoPv6J3JcLhmRyrYegqby+x
         LLKL8NEg3wzWHwWWrxoPIhinEE2tdAvCmk+w4X96c1J/Ix8vMEsYqOG/uvFNohiJ4JG+
         vgmF60xdncncTakDbGf7fGGh02rli8EqrsBlE=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:44 -0200
Message-ID: <b8bf37780910310241s4b98ea30na93d0835cd4a3a00@mail.gmail.com>
Subject: [PATCH 12/16] trivial: fix assorted "[un]used" and "unsure" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bcad97186d2f8173d35e06eeda26b6cfc07b4e82 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:08:38 -0200
Subject: [PATCH 12/16] trivial: fix assorted "[un]used" and "unsure" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/arch/arm/common/scoop.c b/arch/arm/common/scoop.c
index 7713a08..37bda5f 100644
--- a/arch/arm/common/scoop.c
+++ b/arch/arm/common/scoop.c
@@ -82,7 +82,7 @@ static int scoop_gpio_get(struct gpio_chip *chip,
unsigned offset)
 {
 	struct scoop_dev *sdev = container_of(chip, struct scoop_dev, gpio);

-	/* XXX: I'm usure,  but it seems so */
+	/* XXX: I'm unsure, but it seems so */
 	return ioread16(sdev->base + SCOOP_GPRR) & (1 << (offset + 1));
 }

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 7585c41..c52ac9e 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -99,7 +99,7 @@ static struct at_desc *atc_alloc_descriptor(struct
dma_chan *chan,
 }

 /**
- * atc_desc_get - get a unsused descriptor from free_list
+ * atc_desc_get - get an unused descriptor from free_list
  * @atchan: channel we want a new descriptor for
  */
 static struct at_desc *atc_desc_get(struct at_dma_chan *atchan)
diff --git a/fs/cifs/smbdes.c b/fs/cifs/smbdes.c
index 224a1f4..b6b6dcb 100644
--- a/fs/cifs/smbdes.c
+++ b/fs/cifs/smbdes.c
@@ -371,7 +371,7 @@ E_P24(unsigned char *p21, const unsigned char *c8,
unsigned char *p24)
 	smbhash(p24 + 16, c8, p21 + 14, 1);
 }

-#if 0 /* currently unsued */
+#if 0 /* currently unused */
 static void
 D_P16(unsigned char *p14, unsigned char *in, unsigned char *out)
 {
diff --git a/sound/Kconfig b/sound/Kconfig
index 439e15c..b3e53e6 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -58,7 +58,7 @@ config SOUND_OSS_CORE_PRECLAIM
 	  Please read Documentation/feature-removal-schedule.txt for
 	  details.

-	  If unusre, say Y.
+	  If unsure, say Y.

 source "sound/oss/dmasound/Kconfig"

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c08ca66..6141ab4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6617,7 +6617,7 @@ static struct hda_input_mux
alc889A_mb31_capture_source = {
 		/* Front Mic (0x01) unused */
 		{ "Line", 0x2 },
 		/* Line 2 (0x03) unused */
-		/* CD (0x04) unsused? */
+		/* CD (0x04) unused? */
 	},
 };

-- 
1.6.5.2.101.gcd0f8
