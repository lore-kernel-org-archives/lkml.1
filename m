Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXKIXbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXKIXbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXKIXb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:31:26 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57057 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbXKIXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:31:26 -0500
Message-id: <4827138842526222333@pripojeni.net>
Subject: [PATCH 1/5] Net: ibm_newemac, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: <netdev@vger.kernel.org>
Cc: <bryan.wu@analog.com>
Date: Fri, 9 Nov 2007 18:31:26 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ibm_newemac, remove SPIN_LOCK_UNLOCKED

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>

---
commit aefcf0f6b6ab925184e7cebff8b609e4da1f5c0d
tree 9e1e6240f26c759826959e8812885726c520019d
parent f87566db6dd9613dde8de59380cd2f423166511e
author Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:54:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Thu, 25 Oct 2007 11:54:41 +0200

 drivers/net/ibm_newemac/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ibm_newemac/debug.c b/drivers/net/ibm_newemac/debug.c
index 170524e..ada13cd 100644
--- a/drivers/net/ibm_newemac/debug.c
+++ b/drivers/net/ibm_newemac/debug.c
@@ -21,7 +21,7 @@
 
 #include "core.h"
 
-static spinlock_t emac_dbg_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(emac_dbg_lock);
 
 static void emac_desc_dump(struct emac_instance *p)
 {
