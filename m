Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYKUTVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYKUTVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbYKUTVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:21:41 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:9450 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbYKUTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:bcc:subject:date:user-agent:message-id;
        b=gc1yjWTZZG8SwRyCbib2hFsNj09iDsUZXWSEqHyHgOA0J0Epa8hfFBSZHbHQ01m2Xc
         AjzbFMUSS1N4BZTe4H1m/gAgg1U10k6z9qyT2nqW2f2h+5pGtqOIqyuLKdz6FpyvWHbT
         qI++LKgGXLAMAAhnQBA4ihR1/GFhCAVZsox1c=
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/3] net/netlabel/netlabel_domainhash.c: cleanup kernel-doc
Date: Sat, 22 Nov 2008 03:21:19 +0800
User-Agent: sniper-patch-carrier/1.06
Message-ID: <49270a41.0c636e0a.5b79.ffffab7d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no argument named @def in netlbl_domhsh_search_def(),
remove its' comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index 5fadf10..2d81c94 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -153,7 +153,6 @@ static struct netlbl_dom_map *netlbl_domhsh_search(const char *domain)
 /**
  * netlbl_domhsh_search_def - Search for a domain entry
  * @domain: the domain
- * @def: return default if no match is found
  *
  * Description:
  * Searches the domain hash table and returns a pointer to the hash table

