Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628Ab0B0Q6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:58:43 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46242 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030572Ab0B0Q6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:58:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qawUXfj3N1HOLH5xyllhQejwzevIM1Wlr29Bx1BK2QaXdja3aVDQksQ2t+GKfNfM1u
         19QipwLJYpuYf+7YvwZ6fcwCCXztGddtpH4TKRwPLnfLcfn15cGb/ECZ51RteMkqpb0H
         +n0N1SF7rwvs4DEnu2MdbOLC28ItUOQzOwAQk=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH] fs/nls/nls_cp949.c: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:48 +0100
Message-Id: <1267289508-31031-68-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/nls/nls_cp949.c:4437: ERROR: trailing whitespace
[snip]
fs/nls/nls_cp949.c:13786: ERROR: trailing whitespace
fs/nls/nls_cp949.c:13882: ERROR: spaces required around that '==' (ctx:VxV)
fs/nls/nls_cp949.c:13886: ERROR: else should follow close brace '}'

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 fs/nls/nls_cp949.c |  131 ++++++++++++++++++++++++++--------------------------
 1 files changed, 65 insertions(+), 66 deletions(-)

diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 8a7a2fe..296425d 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -4434,38 +4434,38 @@ static const wchar_t c2u_FD[256] = {
 };
 
 static const wchar_t *page_charset2uni[256] = {
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   c2u_81, c2u_82, c2u_83, c2u_84, c2u_85, c2u_86, c2u_87, 
-	c2u_88, c2u_89, c2u_8A, c2u_8B, c2u_8C, c2u_8D, c2u_8E, c2u_8F, 
-	c2u_90, c2u_91, c2u_92, c2u_93, c2u_94, c2u_95, c2u_96, c2u_97, 
-	c2u_98, c2u_99, c2u_9A, c2u_9B, c2u_9C, c2u_9D, c2u_9E, c2u_9F, 
-	c2u_A0, c2u_A1, c2u_A2, c2u_A3, c2u_A4, c2u_A5, c2u_A6, c2u_A7, 
-	c2u_A8, c2u_A9, c2u_AA, c2u_AB, c2u_AC, c2u_AD, c2u_AE, c2u_AF, 
-	c2u_B0, c2u_B1, c2u_B2, c2u_B3, c2u_B4, c2u_B5, c2u_B6, c2u_B7, 
-	c2u_B8, c2u_B9, c2u_BA, c2u_BB, c2u_BC, c2u_BD, c2u_BE, c2u_BF, 
-	c2u_C0, c2u_C1, c2u_C2, c2u_C3, c2u_C4, c2u_C5, c2u_C6, c2u_C7, 
-	c2u_C8, NULL,   c2u_CA, c2u_CB, c2u_CC, c2u_CD, c2u_CE, c2u_CF, 
-	c2u_D0, c2u_D1, c2u_D2, c2u_D3, c2u_D4, c2u_D5, c2u_D6, c2u_D7, 
-	c2u_D8, c2u_D9, c2u_DA, c2u_DB, c2u_DC, c2u_DD, c2u_DE, c2u_DF, 
-	c2u_E0, c2u_E1, c2u_E2, c2u_E3, c2u_E4, c2u_E5, c2u_E6, c2u_E7, 
-	c2u_E8, c2u_E9, c2u_EA, c2u_EB, c2u_EC, c2u_ED, c2u_EE, c2u_EF, 
-	c2u_F0, c2u_F1, c2u_F2, c2u_F3, c2u_F4, c2u_F5, c2u_F6, c2u_F7, 
-	c2u_F8, c2u_F9, c2u_FA, c2u_FB, c2u_FC, c2u_FD, NULL,   NULL,   
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   c2u_81, c2u_82, c2u_83, c2u_84, c2u_85, c2u_86, c2u_87,
+	c2u_88, c2u_89, c2u_8A, c2u_8B, c2u_8C, c2u_8D, c2u_8E, c2u_8F,
+	c2u_90, c2u_91, c2u_92, c2u_93, c2u_94, c2u_95, c2u_96, c2u_97,
+	c2u_98, c2u_99, c2u_9A, c2u_9B, c2u_9C, c2u_9D, c2u_9E, c2u_9F,
+	c2u_A0, c2u_A1, c2u_A2, c2u_A3, c2u_A4, c2u_A5, c2u_A6, c2u_A7,
+	c2u_A8, c2u_A9, c2u_AA, c2u_AB, c2u_AC, c2u_AD, c2u_AE, c2u_AF,
+	c2u_B0, c2u_B1, c2u_B2, c2u_B3, c2u_B4, c2u_B5, c2u_B6, c2u_B7,
+	c2u_B8, c2u_B9, c2u_BA, c2u_BB, c2u_BC, c2u_BD, c2u_BE, c2u_BF,
+	c2u_C0, c2u_C1, c2u_C2, c2u_C3, c2u_C4, c2u_C5, c2u_C6, c2u_C7,
+	c2u_C8, NULL,   c2u_CA, c2u_CB, c2u_CC, c2u_CD, c2u_CE, c2u_CF,
+	c2u_D0, c2u_D1, c2u_D2, c2u_D3, c2u_D4, c2u_D5, c2u_D6, c2u_D7,
+	c2u_D8, c2u_D9, c2u_DA, c2u_DB, c2u_DC, c2u_DD, c2u_DE, c2u_DF,
+	c2u_E0, c2u_E1, c2u_E2, c2u_E3, c2u_E4, c2u_E5, c2u_E6, c2u_E7,
+	c2u_E8, c2u_E9, c2u_EA, c2u_EB, c2u_EC, c2u_ED, c2u_EE, c2u_EF,
+	c2u_F0, c2u_F1, c2u_F2, c2u_F3, c2u_F4, c2u_F5, c2u_F6, c2u_F7,
+	c2u_F8, c2u_F9, c2u_FA, c2u_FB, c2u_FC, c2u_FD, NULL,   NULL,
 };
 
 static const unsigned char u2c_01[512] = {
@@ -13753,37 +13753,37 @@ static const unsigned char u2c_FF[512] = {
 };
 
 static const unsigned char *const page_uni2charset[256] = {
-	NULL,   u2c_01, u2c_02, u2c_03, u2c_04, NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   u2c_11, NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	u2c_20, u2c_21, u2c_22, u2c_23, u2c_24, u2c_25, u2c_26, NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	u2c_30, u2c_31, u2c_32, u2c_33, NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   u2c_4E, u2c_4F, 
-	u2c_50, u2c_51, u2c_52, u2c_53, u2c_54, u2c_55, u2c_56, u2c_57, 
-	u2c_58, u2c_59, u2c_5A, u2c_5B, u2c_5C, u2c_5D, u2c_5E, u2c_5F, 
-	u2c_60, u2c_61, u2c_62, u2c_63, u2c_64, u2c_65, u2c_66, u2c_67, 
-	u2c_68, u2c_69, u2c_6A, u2c_6B, u2c_6C, u2c_6D, u2c_6E, u2c_6F, 
-	u2c_70, u2c_71, u2c_72, u2c_73, u2c_74, u2c_75, u2c_76, u2c_77, 
-	u2c_78, u2c_79, u2c_7A, u2c_7B, u2c_7C, u2c_7D, u2c_7E, u2c_7F, 
-	u2c_80, u2c_81, u2c_82, u2c_83, u2c_84, u2c_85, u2c_86, u2c_87, 
-	u2c_88, u2c_89, u2c_8A, u2c_8B, u2c_8C, u2c_8D, u2c_8E, u2c_8F, 
-	u2c_90, u2c_91, u2c_92, u2c_93, u2c_94, u2c_95, u2c_96, u2c_97, 
-	u2c_98, u2c_99, u2c_9A, u2c_9B, u2c_9C, u2c_9D, u2c_9E, u2c_9F, 
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   u2c_AC, u2c_AD, u2c_AE, u2c_AF, 
-	u2c_B0, u2c_B1, u2c_B2, u2c_B3, u2c_B4, u2c_B5, u2c_B6, u2c_B7, 
-	u2c_B8, u2c_B9, u2c_BA, u2c_BB, u2c_BC, u2c_BD, u2c_BE, u2c_BF, 
-	u2c_C0, u2c_C1, u2c_C2, u2c_C3, u2c_C4, u2c_C5, u2c_C6, u2c_C7, 
-	u2c_C8, u2c_C9, u2c_CA, u2c_CB, u2c_CC, u2c_CD, u2c_CE, u2c_CF, 
-	u2c_D0, u2c_D1, u2c_D2, u2c_D3, u2c_D4, u2c_D5, u2c_D6, u2c_D7, 
-	NULL,   NULL,   NULL,   NULL,   u2c_DC, NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
-	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   
+	NULL,   u2c_01, u2c_02, u2c_03, u2c_04, NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   u2c_11, NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	u2c_20, u2c_21, u2c_22, u2c_23, u2c_24, u2c_25, u2c_26, NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	u2c_30, u2c_31, u2c_32, u2c_33, NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   u2c_4E, u2c_4F,
+	u2c_50, u2c_51, u2c_52, u2c_53, u2c_54, u2c_55, u2c_56, u2c_57,
+	u2c_58, u2c_59, u2c_5A, u2c_5B, u2c_5C, u2c_5D, u2c_5E, u2c_5F,
+	u2c_60, u2c_61, u2c_62, u2c_63, u2c_64, u2c_65, u2c_66, u2c_67,
+	u2c_68, u2c_69, u2c_6A, u2c_6B, u2c_6C, u2c_6D, u2c_6E, u2c_6F,
+	u2c_70, u2c_71, u2c_72, u2c_73, u2c_74, u2c_75, u2c_76, u2c_77,
+	u2c_78, u2c_79, u2c_7A, u2c_7B, u2c_7C, u2c_7D, u2c_7E, u2c_7F,
+	u2c_80, u2c_81, u2c_82, u2c_83, u2c_84, u2c_85, u2c_86, u2c_87,
+	u2c_88, u2c_89, u2c_8A, u2c_8B, u2c_8C, u2c_8D, u2c_8E, u2c_8F,
+	u2c_90, u2c_91, u2c_92, u2c_93, u2c_94, u2c_95, u2c_96, u2c_97,
+	u2c_98, u2c_99, u2c_9A, u2c_9B, u2c_9C, u2c_9D, u2c_9E, u2c_9F,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   u2c_AC, u2c_AD, u2c_AE, u2c_AF,
+	u2c_B0, u2c_B1, u2c_B2, u2c_B3, u2c_B4, u2c_B5, u2c_B6, u2c_B7,
+	u2c_B8, u2c_B9, u2c_BA, u2c_BB, u2c_BC, u2c_BD, u2c_BE, u2c_BF,
+	u2c_C0, u2c_C1, u2c_C2, u2c_C3, u2c_C4, u2c_C5, u2c_C6, u2c_C7,
+	u2c_C8, u2c_C9, u2c_CA, u2c_CB, u2c_CC, u2c_CD, u2c_CE, u2c_CF,
+	u2c_D0, u2c_D1, u2c_D2, u2c_D3, u2c_D4, u2c_D5, u2c_D6, u2c_D7,
+	NULL,   NULL,   NULL,   NULL,   u2c_DC, NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
+	NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,   NULL,
 	NULL,   u2c_F9, u2c_FA, NULL,   NULL,   NULL,   NULL,   u2c_FF, };
 
 static const unsigned char charset2lower[256] = {
@@ -13879,11 +13879,10 @@ static int uni2char(const wchar_t uni,
 		if (out[0] == 0x00 && out[1] == 0x00)
 			return -EINVAL;
 		n = 2;
-	} else if (ch==0 && cl) {
+	} else if ((ch==0) && cl) {
 		out[0] = cl;
 		n = 1;
-	}
-	else
+	} else
 		return -EINVAL;
 
 	return n;
-- 
1.7.0.90.g251a4

