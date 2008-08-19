Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYHRTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYHRTZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYHRTZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:25:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23437 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYHRTZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FXFl7aojLPuKLx5BH+Z2WX/R1mQ3uBKLmKyMNvBnrrA/QPIvMrohQGZzp52Ug0mdvl
         Y60HFckP5dIIDIBfYxFjo28Jjmcd9K1Pt+JbMPPmq6stMG9rj2S3PUAkWmOImPIIbA1F
         7T3llSqpxaqY35WZI5GD4YLolu/1wUjz9Eo3Q=
Message-ID: <48AA20ED.9000705@gmail.com>
Date: Mon, 18 Aug 2008 21:25:01 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: avi@qumranet.com, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM x86_emulate.c: duplicate SrcImm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi avi,

you added this in commit 7d858a19efe5844a98e060931570359b70dea6d1
any idea whether it should be replaced by something else?
---
duplicate SrcImm

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index f2f9046..78b76c9 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -268,7 +268,7 @@ static u16 group_table[] = {
 	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group3*8] =
-	DstMem | SrcImm | ModRM | SrcImm, 0,
+	DstMem | SrcImm | ModRM, 0,
 	DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group4*8] =
