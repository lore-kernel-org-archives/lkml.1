Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZKWTyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZKWTyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbZKWTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:54:40 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:34341 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbZKWTyg (ORCPT
	<rfc822;groupwise-GHaskins@novell.com:0:0>);
	Mon, 23 Nov 2009 14:54:36 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [-next PATCH 2/4] venet: add missing ethtool include
To: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Date: Mon, 23 Nov 2009 14:54:39 -0500
Message-ID: <20091123195439.8184.70167.stgit@dev.haskins.net>
In-Reply-To: <20091123195136.8184.68042.stgit@dev.haskins.net>
References: <20091123195136.8184.68042.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's sloppy to use the facility without officially including its header
file.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/net/vbus-enet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 29b388f..25c6bea 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -22,6 +22,7 @@
 #include <linux/in.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/skbuff.h>

