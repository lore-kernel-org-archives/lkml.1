Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZCJQov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZCJQov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZCJQnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:42 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34581 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <f00a02ec96f66d20d3206bc36c60cd6405bb7fbf.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:47:46 +0000
Subject: [PATCH 03/31] wanrouter: Auto-load wanrouter module when socket opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wanrouter module is missing the net-pf-25 alias that would cause it
to be auto-loaded when a socket of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/wanrouter/wanmain.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 39701de..b1eaa63 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -777,6 +777,7 @@ EXPORT_SYMBOL(register_wan_device);
 EXPORT_SYMBOL(unregister_wan_device);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETPROTO(PF_WANPIPE);
 
 /*
  *	End
-- 
1.6.0.5

