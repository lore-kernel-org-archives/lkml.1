Return-Path: <linux-kernel-owner+w=401wt.eu-S1946241AbXBCCzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946241AbXBCCzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946250AbXBCCgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:23 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52699 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946242AbXBCCf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:57 -0500
Message-Id: <20070203023858.260820000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:13 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org,
       davem@davemloft.net, Bart De Schuymer <bdschuym@pandora.be>
Subject: [patch 09/59] NETFILTER: arp_tables: fix userspace compilation
Content-Disposition: inline; filename=netfilter-arp_tables-fix-userspace-compilation.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

The included patch translates arpt_counters to xt_counters, making
userspace arptables compile against recent kernels.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 include/linux/netfilter_arp/arp_tables.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.19.2.orig/include/linux/netfilter_arp/arp_tables.h
+++ linux-2.6.19.2/include/linux/netfilter_arp/arp_tables.h
@@ -190,6 +190,7 @@ struct arpt_replace
 
 /* The argument to ARPT_SO_ADD_COUNTERS. */
 #define arpt_counters_info xt_counters_info
+#define arpt_counters xt_counters
 
 /* The argument to ARPT_SO_GET_ENTRIES. */
 struct arpt_get_entries

--
