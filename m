Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZAGQOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZAGQOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZAGQN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:13:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:41340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZAGQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QJnuaura2eMPn8ePIQzfY6YMirSU34LN0Pldukh29lnSx7VOFKjwdnR9HKH7rSJgqt
         wTUW5Ty9N07OhAQHvqJ9tz1DfMdMZRDM9NStRNZu3WANH8td4kHdjTNvhPl6/dPYngNH
         jxIMPpOtLQoya110tMJla/k3HpZU8dDidALYI=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/2] netdev: bfin_mac: enable bfin_mac net dev driver for BF51x
Date: Thu,  8 Jan 2009 00:14:38 +0800
Message-Id: <1231344879-26069-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
References: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9a18270..6b1eb43 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -830,7 +830,7 @@ config ULTRA32
 
 config BFIN_MAC
 	tristate "Blackfin on-chip MAC support"
-	depends on NET_ETHERNET && (BF526 || BF527 || BF536 || BF537)
+	depends on NET_ETHERNET && (BF516 || BF518 || BF526 || BF527 || BF536 || BF537)
 	select CRC32
 	select MII
 	select PHYLIB
-- 
1.5.6

