Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYHSPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYHSPnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYHSPno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:43:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:2991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYHSPnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lmrP7OtsIKMQR+GcTy5jWH9H3yILGiuCzXkmd81eTxwKc2iBS1SOrCN/J5HjxlNy+7
         SgIC3ikjgGG4wPUPrFkvmyer2+fUaDW+An/OIHaCLmLemZeBQnOdUwFDqjq3ww8NVqpP
         aMgjlPLRYgxgyKN7ht8QycGoS6zfMd3CB0KSA=
Message-ID: <48AAEA2A.3010107@gmail.com>
Date: Tue, 19 Aug 2008 11:43:38 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
CC: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] powerpc, scc: duplicate SCC_UHC_USBCEN
References: <20080819.220200.-1300539182.kouish@swc.toshiba.co.jp>
In-Reply-To: <20080819.220200.-1300539182.kouish@swc.toshiba.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kou Ishizaki wrote:
> 
> Roel,
> 
>> untested, is it correct?
> 
> Your patch is correct.
> 
> Thanks for your pointing it out and sending the patch. I tested your
> patch and it works good.
> 
> Fortunately, this bug is not fatal because it seems that the SCC-UHC
> sets SCC_UHC_USBEN and SCC_UHC_USBCEN at once.
> 
> 
> Your patch does not contain 'Signed-off-by' line. Could you re-post it
> with your sign?

Sorry for that and thanks for testing.
---
duplicate SCC_UHC_USBCEN

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
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
 
