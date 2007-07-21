Return-Path: <linux-kernel-owner+w=401wt.eu-S937738AbXGUPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937738AbXGUPRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939479AbXGUPE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbXGUPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Gx2tsd0ItL908xP5DD/U+BCCjCl0+EfNv72tKWf48c9d80MBoyK0LJIKEKgfGUidEOl3DJtLEFxsNHKE9jOKk6qxD9UZp7zVHB9PsrnInyLUWhoy3/TX1CBy7V/W/oqm6O3DYirZ1FHkpwRXbzxr0FEqv/S5OBA0rFdSiPwPFvk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][30/37] Clean up duplicate includes in net/netfilter/
Date: Sat, 21 Jul 2007 17:03:47 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, netdev@vger.kernel.org,
       David S Miller <davem@davemloft.net>,
       Harald Welte <laforge@netfilter.org>,
       netfilter-devel@lists.netfilter.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       James Morris <jmorris@redhat.com>, Patrick McHardy <kaber@trash.net>,
       Netfilter Core Team <coreteam@netfilter.org>,
       Bart De Schuymer <bdschuym@pandora.be>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.47827.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	net/netfilter/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 87ad3cc..eb3fe74 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 13d94a0..2a2fd1a 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -9,7 +9,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 93e747b..b906b41 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
 #include <linux/udp.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index f47cab7..a4bab04 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -13,7 +13,6 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/netfilter/xt_physdev.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_bridge.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
