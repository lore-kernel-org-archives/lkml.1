Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbXJMOmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbXJMOmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbXJMOmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:06 -0400
Received: from 1wt.eu ([62.212.114.60]:2906 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbXJMOmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:04 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143447.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:28 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Chuck Ebbert <cebbert@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 06/35] Netfilter: Missing Kbuild entry for netfilter
Content-Disposition: inline; filename=0033-Netfilter-Missing-Kbuild-entry-for-netfilter.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Chuck Ebbert <cebbert@redhat.com>

Add xt_statistic.h to the list of headers to install.

Apparently needed to build newer versions of iptables.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/netfilter/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: 2.6/include/linux/netfilter/Kbuild
===================================================================
--- 2.6.orig/include/linux/netfilter/Kbuild
+++ 2.6/include/linux/netfilter/Kbuild
@@ -28,6 +28,7 @@ header-y += xt_policy.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
 header-y += xt_state.h
+header-y += xt_statistic.h
 header-y += xt_string.h
 header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h

-- 
