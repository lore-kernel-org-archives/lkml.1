Return-Path: <linux-kernel-owner+w=401wt.eu-S964823AbYBGVUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823AbYBGVUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935411AbYBGVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:11:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935409AbYBGVLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:11:34 -0500
Date: Thu, 7 Feb 2008 16:10:55 -0500
From: Jason Baron <jbaron@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch 2/4] make pr_debug() dynamic
Message-ID: <20080207211055.GD14732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-make pptp_msg_name dependent on CONFIG_PR_DEBUG_DYNAMIC

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index b5cb8e8..2be92bd 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -65,7 +65,7 @@ void
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(CONFIG_PR_DEBUG_DYNAMIC)
 /* PptpControlMessageType names */
 const char *const pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
