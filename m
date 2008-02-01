Return-Path: <linux-kernel-owner+w=401wt.eu-S1760365AbYBAU3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760365AbYBAU3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759609AbYBAU3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:29:35 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:38035 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346AbYBAU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:29:33 -0500
X-Greylist: delayed 1643 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 15:29:33 EST
Date: Fri, 1 Feb 2008 21:02:08 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linux-s390@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ext4 bitops
Message-ID: <20080201200208.GA28274@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linux-s390@vger.kernel.org, akpm@linux-foundation.org,
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

diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index dba6fec..47844fc 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -762,6 +762,8 @@ static inline int sched_find_first_bit(unsigned long *b)
  *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
  */
 
+#include <asm-generic/bitops/le.h>
+
 #define ext2_set_bit(nr, addr)       \
 	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_set_bit_atomic(lock, nr, addr)       \
