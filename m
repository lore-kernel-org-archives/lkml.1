Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYIJNFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYIJNFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYIJNE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:04:56 -0400
Received: from mail1.advnet.cz ([213.180.51.194]:37600 "EHLO mail1.advnet.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYIJNEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:04:55 -0400
X-Greylist: delayed 2066 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2008 09:04:55 EDT
X-Spam-Score: 8.581
From: Jiri Slaby <jirislaby@gmail.com>
To: jgarzik@pobox.com
Cc: netdev@vger.kernel.org, rdunlap@xenotime.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH 1/1] NET: fix r8169 linkage
Date: Wed, 10 Sep 2008 14:30:27 +0200
Message-Id: <1221049827-14264-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <20080909080309.3104a54c.randy.dunlap@oracle.com>
References: <20080909080309.3104a54c.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R8169 depends on MII code, thus select MII in Kconfig by R8169.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
---
 drivers/net/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4c818d5..b0a5a17 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2034,6 +2034,7 @@ config R8169
 	tristate "Realtek 8169 gigabit ethernet support"
 	depends on PCI
 	select CRC32
+	select MII
 	---help---
 	  Say Y here if you have a Realtek 8169 PCI Gigabit Ethernet adapter.
 
-- 
1.6.0

