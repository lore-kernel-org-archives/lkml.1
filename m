Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbYEMVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbYEMVEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbYEMVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:04:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:7112 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYEMVEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=qfCP5+OBG/VcOcWye0kn+taSr5rDrE8Ji5QC9jyA3PQPLcUnMQdQKaZIxPCVdavaBG0pUkSK3U7Ltp1lxrpn2QVSnxYNNKkyLTnTIT7a1ThyMfiFxGiZ/y5ynNSpYM2bHnJBopbvGSrlo//rS/QyYKc6pXZtoswXiEdIDv9uxpI=
Message-ID: <482A0254.1020100@gmail.com>
Date: Tue, 13 May 2008 23:04:20 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: daniel.ritz@gmx.ch
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH ?] pcmcia: ti113x: fix ENE_TEST_C9_PFENABLE definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was added in commit 8c3520d4eb3b1bbf2e45fbae8dcfb8db06d5e775
Is the replacement below correct, or should the second ENE_TEST_C9_PFENABLE_F0
be removed? The patch below assumes the former is correct.
---
Fix ENE_TEST_C9_PFENABLE definition.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/pcmcia/ti113x.h b/drivers/pcmcia/ti113x.h
index d29657b..87a5fd5 100644
--- a/drivers/pcmcia/ti113x.h
+++ b/drivers/pcmcia/ti113x.h
@@ -155,7 +155,7 @@
 #define ENE_TEST_C9_TLTENABLE		0x02
 #define ENE_TEST_C9_PFENABLE_F0		0x04
 #define ENE_TEST_C9_PFENABLE_F1		0x08
-#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F0)
+#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F1)
 #define ENE_TEST_C9_WPDISALBLE_F0	0x40
 #define ENE_TEST_C9_WPDISALBLE_F1	0x80
 #define ENE_TEST_C9_WPDISALBLE		(ENE_TEST_C9_WPDISALBLE_F0 | ENE_TEST_C9_WPDISALBLE_F1)
