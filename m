Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270Ab0AQR7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0AQR7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764Ab0AQR7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:59:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41627 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0AQR7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=E0ISjDgXRu5awOhNNOHp7z96wE0a13FUWC6Ld7D2asJgNtnigwobgqY9vVcW4++YEl
         9KxkuJ023OZa9uHfVD+2fpUpg98r03kdXViOka5/9on7izJVg08gwZDqGWGKO6Rohiqn
         KMcUIHVJlYlp7D5zo6f58JcCl0Yul9ASMQwlA=
Message-ID: <4B535106.3060007@gmail.com>
Date: Sun, 17 Jan 2010 19:03:50 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] CRIS v32: Typo in crisv32_arbiter_unwatch()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With id 1 the wrong bp was unwatched.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I guess it should be this?

diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index 84d31bd..82ef293 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -332,7 +332,7 @@ int crisv32_arbiter_unwatch(int id)
 	if (id == 0)
 		intr_mask.bp0 = regk_marb_no;
 	else if (id == 1)
-		intr_mask.bp2 = regk_marb_no;
+		intr_mask.bp1 = regk_marb_no;
 	else if (id == 2)
 		intr_mask.bp2 = regk_marb_no;
 	else if (id == 3)
