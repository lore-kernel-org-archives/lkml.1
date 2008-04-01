Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYDATu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYDATu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYDATuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:50:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbYDATuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:50:50 -0400
Date: Tue, 1 Apr 2008 15:50:48 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch 2/3] dynamic printk - compile fix
Message-ID: <20080401195048.GD12029@redhat.com>
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
index b5cb8e8..2f85295 100644
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
