Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXKMHWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXKMHWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXKMHW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:22:26 -0500
Received: from lixom.net ([66.141.50.11]:59590 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXKMHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:22:25 -0500
Date: Tue, 13 Nov 2007 01:23:13 -0600
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Fix warning for token-ring from sysctl checker
Message-ID: <20071113072313.GB16842@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As seen when booting ppc64_defconfig:

sysctl table check failed: /net/token-ring .3.14 procname does not match binary path procname


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 5a2f2b2..4abc6d2 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_table[] = {
 	{ NET_ROSE,		"rose",		trans_net_rose_table },
 	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
 	{ NET_X25,		"x25",		trans_net_x25_table },
-	{ NET_TR,		"tr",		trans_net_tr_table },
+	{ NET_TR,		"token-ring",	trans_net_tr_table },
 	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
 	/*  NET_ECONET not used */
 	{ NET_SCTP,		"sctp",		trans_net_sctp_table },
