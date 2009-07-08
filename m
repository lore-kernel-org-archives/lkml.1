Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZGHQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZGHQJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759456AbZGHQG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:06:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:53291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbZGHQG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:06:28 -0400
Subject: [PATCH 40/44] includecheck fix: include/linux, net_dropmon.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:24:16 +0530
Message-Id: <1247068456.4382.104.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/linux/net_dropmon.h: linux/types.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/net_dropmon.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/net_dropmon.h b/include/linux/net_dropmon.h
index 3ceb0cc..2a73946 100644
--- a/include/linux/net_dropmon.h
+++ b/include/linux/net_dropmon.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <linux/netlink.h>
-#include <linux/types.h>
 
 struct net_dm_drop_point {
 	__u8 pc[8];
-- 
1.6.0.6



