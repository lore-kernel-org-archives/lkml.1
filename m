Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbYEVVRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbYEVVRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbYEVVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:17:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbYEVVRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:17:12 -0400
Date: Thu, 22 May 2008 17:16:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] debug printk infrastructure -compile fixes
Message-ID: <20080522211639.GD28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 net/netfilter/nf_conntrack_pptp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 97e54b0..7fea304 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -65,7 +65,7 @@ void
 			     struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_pptp_hook_expectfn);
 
-#ifdef DEBUG
+#if defined(DEBUG) || defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 /* PptpControlMessageType names */
 const char *const pptp_msg_name[] = {
 	"UNKNOWN_MESSAGE",
-- 
1.5.4.5

