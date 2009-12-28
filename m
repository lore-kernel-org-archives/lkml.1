Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbZL1Vsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbZL1Vsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZL1Vsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:48:53 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:58427 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZL1Vsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:48:52 -0500
Date: Mon, 28 Dec 2009 16:48:08 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: linux-rdma@vger.kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] INFINIBAND:  Correct CONFIG_IPv6 to CONFIG_IPV6.
Message-ID: <alpine.LFD.2.00.0912281644290.3429@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct misspelled "CONFIG_IPv6" that was introduced in commit
d14714df61681cfecf945a58436edf197327e87f, should be all uppercase.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fbdd731..cc9b594 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2083,7 +2083,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
 			       struct sockaddr *addr)
 {
-#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	struct sockaddr_in6 *sin6;

 	if (addr->sa_family != AF_INET6)

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
