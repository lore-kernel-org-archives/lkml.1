Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXK1OhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXK1OhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbXK1Of3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:29 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62246 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757814AbXK1OfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:24 -0500
Message-Id: <20071128143438.547001000@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:47 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 5/7] ps3: Kill unused ps3_repository_bump_device()
Content-Disposition: inline; filename=ps3-wip/kill-unused-ps3_repository_bump_device.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Kill unused ps3_repository_bump_device()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/platform.h |    6 ------
 1 files changed, 6 deletions(-)

--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -144,12 +144,6 @@ struct ps3_repository_device {
 	u64 dev_id;
 };
 
-static inline struct ps3_repository_device *ps3_repository_bump_device(
-	struct ps3_repository_device *repo)
-{
-	repo->dev_index++;
-	return repo;
-}
 int ps3_repository_find_device(struct ps3_repository_device *repo);
 int ps3_repository_find_device_by_id(struct ps3_repository_device *repo,
 				     u64 bus_id, u64 dev_id);

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

