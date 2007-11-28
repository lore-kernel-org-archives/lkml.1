Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXK1TGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXK1TGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759421AbXK1TFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:05:35 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:42876 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbXK1TFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:05:34 -0500
Date: Wed, 28 Nov 2007 14:04:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - after_sleep_interval should return something
Message-ID: <20071128190440.GA8308@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This should be merged with uml-fix-no_hz-busy-loop.patch ]

I forgot to have an int-returning function actually return something.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/time.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2007-11-28 10:42:52.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/time.c	2007-11-28 11:37:19.000000000 -0500
@@ -77,6 +77,7 @@ long long os_nsecs(void)
 #ifdef UML_CONFIG_NO_HZ
 static int after_sleep_interval(struct timespec *ts)
 {
+	return 0;
 }
 #else
 static inline long long timespec_to_us(const struct timespec *ts)
