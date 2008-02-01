Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYBAU37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYBAU37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759793AbYBAU3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:29:37 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:38036 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759345AbYBAU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:29:33 -0500
Date: Fri, 1 Feb 2008 21:02:40 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ext4 bitops
Message-ID: <20080201200240.GA28566@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ext4 bitops.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 220d9a7..d0980df 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -363,6 +363,8 @@ unsigned long generic_find_next_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
+#include <asm-generic/bitops/le.h>
+
 #define ext2_set_bit(nr,addr) \
 	__test_and_set_le_bit((nr), (unsigned long*)addr)
 #define ext2_clear_bit(nr, addr) \
