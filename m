Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbXGFLa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbXGFLa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbXGFLau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:30:50 -0400
Received: from mail.macqel.be ([194.78.208.39]:11789 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbXGFLat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:30:49 -0400
Date: Fri, 6 Jul 2007 13:30:44 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] net : make ip_tos2prio const
Message-ID: <20070706113044.GA12699@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Make ip_tos2prio `const'.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a include/net/route.h
--- a/include/net/route.h	Thu Jul  5 16:10:16 2007 -0700
+++ b/include/net/route.h	Fri Jul  6 13:23:35 2007 +0200
@@ -136,7 +136,7 @@ static inline void ip_rt_put(struct rtab
 
 #define IPTOS_RT_MASK	(IPTOS_TOS_MASK & ~3)
 
-extern __u8 ip_tos2prio[16];
+extern const __u8 ip_tos2prio[16];
 
 static inline char rt_tos2priority(u8 tos)
 {
diff -r 6c0a10cc415a net/ipv4/route.c
--- a/net/ipv4/route.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/net/ipv4/route.c	Fri Jul  6 13:23:35 2007 +0200
@@ -168,7 +168,7 @@ static struct dst_ops ipv4_dst_ops = {
 
 #define ECN_OR_COST(class)	TC_PRIO_##class
 
-__u8 ip_tos2prio[16] = {
+const __u8 ip_tos2prio[16] = {
 	TC_PRIO_BESTEFFORT,
 	ECN_OR_COST(FILLER),
 	TC_PRIO_BESTEFFORT,
