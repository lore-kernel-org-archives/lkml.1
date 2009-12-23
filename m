Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZLWBk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZLWBk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZLWBk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:40:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62557 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbZLWBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Tmt2XjpUHga5WeMgEzAOEpAWl2x8vBaY+Wm7YnqmWxldRoCSSC1lpLcedXFs5/ofc/
         C28U7QsIZS7BHts+xR0KmwaOUiCxzxIJJZvuPMU13mjaxnkSZ2MOdQ+5wdXEivLAKgvK
         2iJjPZ4pEQos+Xvuc8rmGlaNlGUCqHMUlFQrY=
Message-ID: <4B317599.30809@gmail.com>
Date: Wed, 23 Dec 2009 02:42:49 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP3: add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not(!) has a higher precedence than bit and(&).

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/arm/plat-omap/include/plat/control.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/control.h b/arch/arm/plat-omap/include/plat/control.h
index 2ae8843..a745d62 100644
--- a/arch/arm/plat-omap/include/plat/control.h
+++ b/arch/arm/plat-omap/include/plat/control.h
@@ -147,7 +147,7 @@
 #define OMAP343X_CONTROL_IVA2_BOOTADDR	(OMAP2_CONTROL_GENERAL + 0x0190)
 #define OMAP343X_CONTROL_IVA2_BOOTMOD	(OMAP2_CONTROL_GENERAL + 0x0194)
 #define OMAP343X_CONTROL_DEBOBS(i)	(OMAP2_CONTROL_GENERAL + 0x01B0 \
-					+ ((i) >> 1) * 4 + (!(i) & 1) * 2)
+					+ ((i) >> 1) * 4 + (!((i) & 1)) * 2)
 #define OMAP343X_CONTROL_PROG_IO0	(OMAP2_CONTROL_GENERAL + 0x01D4)
 #define OMAP343X_CONTROL_PROG_IO1	(OMAP2_CONTROL_GENERAL + 0x01D8)
 #define OMAP343X_CONTROL_DSS_DPLL_SPREADING	(OMAP2_CONTROL_GENERAL + 0x01E0)
