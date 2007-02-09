Return-Path: <linux-kernel-owner+w=401wt.eu-S1946577AbXBIPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946577AbXBIPhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946570AbXBIPfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946569AbXBIPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f8Kgu8rYGRv+IdwhEswoS32pqR0u/BepJgUL0vtGalK41P/szUzdhrhhUZ+MsdC+g7voIaLGW8j4A/N5xWSwDc6/jffyTr7MMt/wgRYGMgRRyp4jU4XY4uDYs5tHEY0zyM7vfq10MKceXghRh1vLvG9AP29K1/2wLz3r8Sm+VCQ=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, patrick@tykepenguin.com, davem@davemloft.net,
       kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org
Subject: [PATCH 29/34] __initdata cleanup - net
Date: Fri, 9 Feb 2007 17:33:11 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091733.11870.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/net/decnet/dn_dev.c linux-2.6.20-rc6-mm3/net/decnet/dn_dev.c
--- linux-2.6.20-rc6-mm3.org/net/decnet/dn_dev.c	2007-01-31 22:15:42.000000000 +0200
+++ linux-2.6.20-rc6-mm3/net/decnet/dn_dev.c	2007-01-31 22:19:30.000000000 +0200
@@ -1461,7 +1461,7 @@ static struct rtnetlink_link dnet_rtnetl
 
 };
 
-static int __initdata addr[2];
+static int __initdata addr[2] = {0, 0};
 module_param_array(addr, int, NULL, 0444);
 MODULE_PARM_DESC(addr, "The DECnet address of this machine: area,node");
 
diff -urNp linux-2.6.20-rc6-mm3.org/net/ipv4/route.c linux-2.6.20-rc6-mm3/net/ipv4/route.c
--- linux-2.6.20-rc6-mm3.org/net/ipv4/route.c	2007-01-31 22:15:42.000000000 +0200
+++ linux-2.6.20-rc6-mm3/net/ipv4/route.c	2007-01-31 22:19:30.000000000 +0200
@@ -3103,7 +3103,7 @@ static int ip_rt_acct_read(char *buffer,
 #endif /* CONFIG_PROC_FS */
 #endif /* CONFIG_NET_CLS_ROUTE */
 
-static __initdata unsigned long rhash_entries;
+static __initdata unsigned long rhash_entries = 0l;
 static int __init set_rhash_entries(char *str)
 {
 	if (!str)
diff -urNp linux-2.6.20-rc6-mm3.org/net/ipv4/tcp.c linux-2.6.20-rc6-mm3/net/ipv4/tcp.c
--- linux-2.6.20-rc6-mm3.org/net/ipv4/tcp.c	2007-01-31 22:15:42.000000000 +0200
+++ linux-2.6.20-rc6-mm3/net/ipv4/tcp.c	2007-01-31 22:19:30.000000000 +0200
@@ -2385,7 +2385,7 @@ EXPORT_SYMBOL(__tcp_put_md5sig_pool);
 extern void __skb_cb_too_small_for_tcp(int, int);
 extern struct tcp_congestion_ops tcp_reno;
 
-static __initdata unsigned long thash_entries;
+static __initdata unsigned long thash_entries = 0l;
 static int __init set_thash_entries(char *str)
 {
 	if (!str)
