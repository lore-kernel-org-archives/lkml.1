Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYFBNf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYFBNf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbYFBNfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:35:18 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:55992 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbYFBNfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:35:17 -0400
Message-ID: <4843F6D2.6020606@de.ibm.com>
Date: Mon, 02 Jun 2008 15:34:10 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 2/6] kernel: introduce GCC_VERSION_LOWER macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Use GCC_VERSION_LOWER() to check for gcc versions below a certain level.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc4/include/linux/compiler-gcc.h
===================================================================
--- linux-2.6.26-rc4.orig/include/linux/compiler-gcc.h
+++ linux-2.6.26-rc4/include/linux/compiler-gcc.h
@@ -6,6 +6,9 @@
  * Common definitions for all gcc versions go here.
  */
 
+#define GCC_VERSION_LOWER(major, minor) ((__GNUC__ < major) || \
+					 (__GNUC__ == major) && \
+					 (__GNUC_MINOR__ < minor))
 
 /* Optimization barrier */
 /* The "volatile" is due to gcc bugs */


