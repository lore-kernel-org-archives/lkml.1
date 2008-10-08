Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYJHTn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYJHTn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYJHTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8491 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbYJHTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tQgys5HqDGwuq7ELbctEbbTngzv471ABU4BQV3WcxOTJMEr9aWBqQneOR7KeSw29Wi
         1qkAxs48EHyV0Y+rhkYBnKNHGvenIEaOQQPet5SOnIQe8r1v98lQZngbTwlEcR9mxvNL
         Bb0q9xRF4mgyyJ2Zdv6ICYVMDHL2zKnKpmIYw=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 08/10] ixj: update quickly readable comments to match the data initializations.
Date: Wed,  8 Oct 2008 14:41:43 -0600
Message-Id: <c151f6b92c2b5a21d74ac20d7ef57b4960d6935c.1223497217.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <d9e83f28187798f57dc2174a19eda735af09a90f.1223497217.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
 <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
 <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
 <d9e83f28187798f57dc2174a19eda735af09a90f.1223497217.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 3b1315f..3e19357 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7794,7 +7794,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->daa_country = DAA_US;
 	zero_caller_id(j);
 
-/* Bytes for IM-filter part 1 (04): 0E,32,E2,2F,C2,5A,C0,00 */
+/* Bytes for IM-filter part 1 (04): 03,4B,5D,CD,24,C5,A0,00 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[7] = 0x03;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[6] = 0x4B;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[5] = 0x5D;
@@ -7803,7 +7803,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[2] = 0xC5;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[1] = 0xA0;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[0] = 0x00;
-/* Bytes for IM-filter part 2 (05): 72,85,00,0E,2B,3A,D0,08 */
+/* Bytes for IM-filter part 2 (05): 71,1A,00,0A,B5,33,E0,08 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[7] = 0x71;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[6] = 0x1A;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[5] = 0x00;
@@ -7812,7 +7812,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[2] = 0x33;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[1] = 0xE0;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[0] = 0x08;
-/* Bytes for FRX-filter       (08): 03,8F,48,F2,8F,48,70,08 */
+/* Bytes for FRX-filter       (08): 05,A3,72,34,3F,3B,30,08 */
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[7] = 0x05;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[6] = 0xA3;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[5] = 0x72;
@@ -7821,7 +7821,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[2] = 0x3B;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[1] = 0x30;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRXFilterCoeff[0] = 0x08;
-/* Bytes for FRR-filter       (07): 04,8F,38,7F,9B,EA,B0,08 */
+/* Bytes for FRR-filter       (07): 05,87,F9,3E,32,DA,B0,08 */
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[7] = 0x05;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[6] = 0x87;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[5] = 0xF9;
@@ -7830,17 +7830,17 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[2] = 0xDA;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[1] = 0xB0;
 	j->m_DAAShadowRegs.COP_REGS.COP.FRRFilterCoeff[0] = 0x08;
-/* Bytes for AX-filter        (0A): 16,55,DD,CA */
+/* Bytes for AX-filter        (0A): 41,B5,DD,CA */
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[3] = 0x41;
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[2] = 0xB5;
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[1] = 0xDD;
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[0] = 0xCA;
-/* Bytes for AR-filter        (09): 52,D3,11,42 */
+/* Bytes for AR-filter        (09): 25,C7,10,D6 */
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[3] = 0x25;
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[2] = 0xC7;
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[1] = 0x10;
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[0] = 0xD6;
-/* Bytes for TH-filter part 1 (00): 00,42,48,81,B3,80,00,98 */
+/* Bytes for TH-filter part 1 (00): 00,42,48,81,A5,80,00,98 */
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[7] = 0x00;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[6] = 0x42;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[5] = 0x48;
@@ -7849,7 +7849,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[2] = 0x80;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[1] = 0x00;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_1[0] = 0x98;
-/* Bytes for TH-filter part 2 (01): 02,F2,33,A0,68,AB,8A,AD */
+/* Bytes for TH-filter part 2 (01): 02,A2,2B,B0,E8,AB,81,CC */
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[7] = 0x02;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[6] = 0xA2;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[5] = 0x2B;
@@ -7858,7 +7858,7 @@ static void DAA_Coeff_US(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[2] = 0xAB;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[1] = 0x81;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_2[0] = 0xCC;
-/* Bytes for TH-filter part 3 (02): 00,88,DA,54,A4,BA,2D,BB */
+/* Bytes for TH-filter part 3 (02): 00,88,D2,24,BA,A9,3B,A6 */
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[7] = 0x00;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[6] = 0x88;
 	j->m_DAAShadowRegs.COP_REGS.COP.THFilterCoeff_3[5] = 0xD2;
@@ -8045,7 +8045,7 @@ static void DAA_Coeff_France(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[2] = 0xAF;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[1] = 0xA0;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_1[0] = 0x00;
-/* Bytes for IM-filter part 2 (05): 67,CE,00,0C,22,33,E0,08 */
+/* Bytes for IM-filter part 2 (05): 67,CE,00,2C,22,33,E0,08 */
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[7] = 0x67;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[6] = 0xCE;
 	j->m_DAAShadowRegs.COP_REGS.COP.IMFilterCoeff_2[5] = 0x00;
@@ -8077,7 +8077,7 @@ static void DAA_Coeff_France(IXJ *j)
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[2] = 0xB5;
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[1] = 0xDD;
 	j->m_DAAShadowRegs.COP_REGS.COP.AXFilterCoeff[0] = 0xCA;
-/* Bytes for AR-filter        (09): 52,C7,10,D6 */
+/* Bytes for AR-filter        (09): E2,C7,10,D6 */
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[3] = 0xE2;
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[2] = 0xC7;
 	j->m_DAAShadowRegs.COP_REGS.COP.ARFilterCoeff[1] = 0x10;
-- 
1.5.6.4

