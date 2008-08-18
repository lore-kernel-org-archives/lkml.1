Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYHRQGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYHRQGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYHRQGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:06:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:63968 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYHRQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QPm2+wFwVp4Lhm9RG67eBGioH/8f3eLtcpNn07TLVBpUiC8lxo7/E/HfF5LcuLhj8Q
         yUNdIhN4bpC8bU9uNEy88HQc316ObKp1pYTHUGIuCG+GuXFYgMwH9l7l0hUp/g6E8x+K
         1cPvVDRusmLCKnHeDQXjFZ60kt9y2OMrAwD3g=
Message-ID: <48A9F256.2000901@gmail.com>
Date: Mon, 18 Aug 2008 18:06:14 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: kou.ishizaki@toshiba.co.jp, paulus@samba.org, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc, scc: duplicate SCC_UHC_USBCEN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it correct?
---
arch/powerpc/platforms/cell/celleb_scc.h:224:
#define SCC_UHC_USBEN           0x00010000
#define SCC_UHC_USBCEN          0x00020000

---
diff --git a/arch/powerpc/platforms/cell/celleb_scc_uhc.c b/arch/powerpc/platforms/cell/celleb_scc_uhc.c
index d63b720..b086f33 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_uhc.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_uhc.c
@@ -31,7 +31,7 @@
 
 static inline int uhc_clkctrl_ready(u32 val)
 {
-	const u32 mask = SCC_UHC_USBCEN | SCC_UHC_USBCEN;
+	const u32 mask = SCC_UHC_USBCEN | SCC_UHC_USBEN;
 	return((val & mask) == mask);
 }
 
