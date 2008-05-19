Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYESIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYESIny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYESInp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:43:45 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:50552 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbYESInn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:43:43 -0400
Message-ID: <48313DB4.8000102@de.ibm.com>
Date: Mon, 19 May 2008 10:43:32 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 2/7] kernel: introduce GCC_VERSION_LOWER macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

GCC_VERSION_LOWER() can be used to check for gcc versions below a
certain level.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc3/include/linux/compiler-gcc.h
===================================================================
--- linux-2.6.26-rc3.orig/include/linux/compiler-gcc.h
+++ linux-2.6.26-rc3/include/linux/compiler-gcc.h
@@ -6,6 +6,9 @@
  * Common definitions for all gcc versions go here.
  */
 
+#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
+					 (__GNUC__ == major) && \
+					 (__GNUC_MINOR__ < minor))
 
 /* Optimization barrier */
 /* The "volatile" is due to gcc bugs */






