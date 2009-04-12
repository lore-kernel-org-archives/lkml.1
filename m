Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZDLT7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZDLT7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 15:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZDLT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 15:58:56 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:52321 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZDLT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 15:58:55 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH] remove broken macro from dvb stv0900_priv.h
Date: Sun, 12 Apr 2009 21:58:52 +0200
Message-Id: <1239566332-8346-1-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It both has unbalanced parentheses and == is not = and it's not used
anywhere anyway.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
---
 drivers/media/dvb/frontends/stv0900_priv.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0900_priv.h b/drivers/media/dvb/frontends/stv0900_priv.h
index 762d5af..67dc8ec 100644
--- a/drivers/media/dvb/frontends/stv0900_priv.h
+++ b/drivers/media/dvb/frontends/stv0900_priv.h
@@ -60,8 +60,6 @@
 		} \
 	} while (0)
 
-#define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a))
-
 static int stvdebug;
 
 #define dprintk(args...) \
-- 
1.5.6.3

