Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbXGJJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbXGJJmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764203AbXGJJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:42:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:23374 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764122AbXGJJmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:42:01 -0400
Date: Tue, 10 Jul 2007 11:42:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] make timespec_equal() take const arguments
In-Reply-To: <20070710023754.77c42078.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707101141250.11053@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707091846090.2887@fbirervta.pbzchgretzou.qr>
 <20070710023754.77c42078.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make arguments of timespec_equal() const struct timespec.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/linux/time.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22/include/linux/time.h
===================================================================
--- linux-2.6.22.orig/include/linux/time.h
+++ linux-2.6.22/include/linux/time.h
@@ -36,7 +36,8 @@ struct timezone {
 #define NSEC_PER_SEC	1000000000L
 #define FSEC_PER_SEC	1000000000000000L
 
-static inline int timespec_equal(struct timespec *a, struct timespec *b)
+static inline int timespec_equal(const struct timespec *a,
+                                 const struct timespec *b)
 {
 	return (a->tv_sec == b->tv_sec) && (a->tv_nsec == b->tv_nsec);
 }
