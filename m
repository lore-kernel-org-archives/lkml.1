Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZJIOOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZJIOOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 10:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760883AbZJIOOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 10:14:46 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36029 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbZJIOOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 10:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=ulUG1oc27mBVtF49g7JLE+IR/h0+xOFQWeKO0PtKdkcx+FA19J6u9I9NSM0DbSxDX0
         TI9tg1i3HIPKQvSq5E9mKOZDL9EXOU522o98Megz/4m3ht8FDu1vOYSWzHZFr3oMb2AV
         iRHNStfS35tpQLZYweEnFOypRgfC9PXwzYSCY=
From: Miguel Boton <waninkoko@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: add 'struct b43_wl' missing declaration
Date: Fri, 9 Oct 2009 16:13:53 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-zen2; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mb@bu3sch.de, linville@tuxdriver.com,
       bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910091613.53960.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct b43_wl' declaration is missing at 'leds.h'.
It should be declared to avoid getting some GCC warnings at 'b43_leds_unregister'.

Signed-off-by: Miguel Botón <mboton@gmail.com>

---

 drivers/net/wireless/b43/leds.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/leds.h b/drivers/net/wireless/b43/leds.h
index 4c56187..32b66d5 100644
--- a/drivers/net/wireless/b43/leds.h
+++ b/drivers/net/wireless/b43/leds.h
@@ -1,6 +1,7 @@
 #ifndef B43_LEDS_H_
 #define B43_LEDS_H_
 
+struct b43_wl;
 struct b43_wldev;
 
 #ifdef CONFIG_B43_LEDS
