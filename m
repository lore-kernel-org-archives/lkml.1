Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYGFP6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYGFP6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 11:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYGFP6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 11:58:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:49516 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYGFP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 11:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=AphLJ6EIVed3pA/aoGSi5ceR6U9g13tW1IKIZ4tMP5yUI0sqw6/B5VGWzfVy/KMIto
         f5jbany3mo73ssbcQrlzHJYI5MYfYnckC/OljhWPPDNaVvJ9HHi62lpDCcDDNz+nQEj0
         Ph565S6nHu3WjxHi1etGzW8E8EMCoEn/X1iq8=
Message-ID: <a4423d670807060858nf8ec980gcd0475ccdc55b94d@mail.gmail.com>
Date: Sun, 6 Jul 2008 19:58:36 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: rmk+kernel@arm.linux.org.uk, dbaryshkov@gmail.com,
       kernel-janitors@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] [ARM] Tosa: remove double inclusion of linux/delay.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

The patch applies to the linux-next tree.

[ARM] Tosa: Remove double inclusion of linux/delay.h

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
index 86f1ea5..f4d9d77 100644
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -26,7 +26,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/pm.h>
-#include <linux/delay.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
