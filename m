Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYD2SoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYD2SoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYD2SoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:44:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbYD2SoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:44:04 -0400
Date: Tue, 29 Apr 2008 14:43:09 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/3] dyanmic_printk: compile fix
Message-ID: <20080429184309.GC8717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-make pptp_msg_name dependent on CONFIG_DYNAMIC_PRINTK

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 97e54b0..9f2dfbd 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -65,7 +65,7 @@ void
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_PRINTK)
 /* PptpControlMessageType names */
 const char *const pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
