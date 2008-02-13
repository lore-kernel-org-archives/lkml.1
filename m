Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbYBMVdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbYBMVdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761933AbYBMVaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:06 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47466 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762987AbYBMVaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:02 -0500
Date: Wed, 13 Feb 2008 23:29:46 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] unexport __inet_hash_connect
Message-ID: <20080213212946.GK3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL_GPL(__inet_hash_connect).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ffa30930d4ba630514fd93ded245456f05358140 diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 9cac6c0..e6a0072 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -494,7 +494,6 @@ out:
 		return ret;
 	}
 }
-EXPORT_SYMBOL_GPL(__inet_hash_connect);
 
 /*
  * Bind a port for a connect operation and hash it.

