Return-Path: <linux-kernel-owner+w=401wt.eu-S932531AbZKDRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbZKDRif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZKDRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:36:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbZKDRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=E+W55c4pMESHj845NEBpkDPn4RvGYJ8r7NpqH62LAS9N5/GVP4Fsa+26ptLqwb7LLN
         pwd1UFE9Mr8ZmuefoPfB81hGF/CeTh0STwJ4OeJ28EcR7uizMOQ04STFLz0bRv0wDqzb
         4JcgemDWp1xx58xaCEv3MnswNfc0+M9vdowYo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:33 +0100
Message-Id: <20091104173633.28463.3378.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 37/41] rt2x00: remove needless ifdefs from rt2x00leds.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: remove needless ifdefs from rt2x00leds.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00leds.h |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2x00leds.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00leds.h
+++ b/drivers/net/wireless/rt2x00/rt2x00leds.h
@@ -33,8 +33,6 @@ enum led_type {
 	LED_TYPE_QUALITY,
 };
 
-#ifdef CONFIG_RT2X00_LIB_LEDS
-
 struct rt2x00_led {
 	struct rt2x00_dev *rt2x00dev;
 	struct led_classdev led_dev;
@@ -45,6 +43,4 @@ struct rt2x00_led {
 #define LED_REGISTERED		( 1 << 1 )
 };
 
-#endif /* CONFIG_RT2X00_LIB_LEDS */
-
 #endif /* RT2X00LEDS_H */
