Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbXFIL6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbXFIL6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXFIL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:58:37 -0400
Received: from zakalwe.fi ([80.83.5.154]:48237 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbXFIL6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:58:36 -0400
Date: Sat, 9 Jun 2007 14:57:27 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove unnecessary ARM SHA-1 preprocessor directive
Message-ID: <20070609115727.GK10873@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unnecessary C style preprocessor directive from ARM SHA-1 
assember implementation. It confuses sloccount.

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>


diff --git a/arch/arm/lib/sha1.S b/arch/arm/lib/sha1.S
index ff6ece4..67c2bf4 100644
--- a/arch/arm/lib/sha1.S
+++ b/arch/arm/lib/sha1.S
@@ -29,7 +29,7 @@ ENTRY(sha_transform)
 	stmfd	sp!, {r4 - r8, lr}
 
 	@ for (i = 0; i < 16; i++)
-	@         W[i] = be32_to_cpu(in[i]); */
+	@         W[i] = be32_to_cpu(in[i]);
 
 #ifdef __ARMEB__
 	mov	r4, r0

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
