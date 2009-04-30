Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZD3Pgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZD3Pgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZD3PgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:36:05 -0400
Received: from support.balabit.hu ([195.70.41.86]:35113 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932145AbZD3PgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:36:00 -0400
From: Laszlo Attila Toth <panther@balabit.hu>
To: davem@davemloft.net, kaber@trash.net
Cc: mingo@elte.hu, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       hidden@sch.bme.hu, linux-kernel@vger.kernel.org,
       Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] xt_socket: checks for the state of nf_conntrack
Date: Thu, 30 Apr 2009 17:35:55 +0200
Message-Id: <1241105755-10017-1-git-send-email-panther@balabit.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xt_socket can use connection tracking, and checks whether it is a module.

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 881203c..cb3ad74 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -837,6 +837,7 @@ config NETFILTER_XT_MATCH_SOCKET
 	depends on NETFILTER_TPROXY
 	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
+	depends on !NF_CONNTRACK || NF_CONNTRACK
 	select NF_DEFRAG_IPV4
 	help
 	  This option adds a `socket' match, which can be used to match
-- 
1.6.2.2.404.ge96f3

