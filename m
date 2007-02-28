Return-Path: <linux-kernel-owner+w=401wt.eu-S1751094AbXB1ThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbXB1ThR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXB1ThQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:37:16 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39220 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbXB1ThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:37:15 -0500
Subject: [PATCH 1/5] Add LZO compression support to the kernel
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Wed, 28 Feb 2007 19:13:24 +0000
Message-Id: <1172690004.16062.136.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add LZO1X compression/decompression support to the kernel.

This is based on the standard userspace lzo library, particularly 
minilzo with the headers much trimmed down and simplified for kernel
use. Its structured so that it should still diff with the userspace
version for ease of future updating.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 include/linux/lzo.h |   63 +
 lib/Kconfig         |    5 
 lib/Makefile        |    1 
 lib/lzo/Makefile    |    3 
 lib/lzo/lzoconf.h   |  186 +++++
 lib/lzo/lzodefs.h   |  463 +++++++++++++
 lib/lzo/lzointf.c   |   37 +
 lib/lzo/minilzo.c   | 1771
++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 2529 insertions(+)

http://folks.o-hand.com/richard/lzo/lzo_kernel.patch
(since it exceeds the file size limit for LKML)

I can email inline if anyone prefers it that way.

