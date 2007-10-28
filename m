Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXJ1W1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXJ1W1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 18:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbXJ1W1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 18:27:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22638 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbXJ1W1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 18:27:41 -0400
Date: Sun, 28 Oct 2007 15:25:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: webmaster@dragonslave.de, akpm <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Exner <dex@dragonslave.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Michal Januszewski <spock@gentoo.org>
Subject: [PATCH] sysctl: fix token-ring procname
Message-Id: <20071028152533.7606cf45.randy.dunlap@oracle.com>
In-Reply-To: <200710252037.09667.dex@dragonslave.de>
References: <200710252037.09667.dex@dragonslave.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: Eric W. Biederman <ebiederm@xmission.com>

Correct the token-ring sysctl procname.

Reported by: Daniel Exner <dex@dragonslave.de>:

Ah, and token ring tells me something like
"/net/token-ring ,3.14 sysctl failed check procname does not match binary path 
procname"
But kernel boots otherwise and I got no chance to test tr itself is working.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc1.orig/kernel/sysctl_check.c
+++ linux-2.6.24-rc1/kernel/sysctl_check.c
@@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_ROSE,		"rose",		trans_net_rose_table },
 	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
 	{ NET_X25,		"x25",		trans_net_x25_table },
-	{ NET_TR,		"tr",		trans_net_tr_table },
+	{ NET_TR,		"token-ring",	trans_net_tr_table },
 	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
 	/*  NET_ECONET not used */
 	{ NET_SCTP,		"sctp",		trans_net_sctp_table },
