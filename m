Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbXDDUVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbXDDUVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbXDDUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:21:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXDDUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:21:04 -0400
Message-ID: <461408A6.5010005@online.de>
Date: Wed, 04 Apr 2007 22:20:54 +0200
From: Thomas Bittermann <t.bittermann@online.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18oGyDXxPaHEelm7lvAsKChlWJDDEVTpc9vrm4
 XoUTzsId+rA7iMOef4FJD8GUVvPnoG2Elqe5Rt2+yUFJReVksU
 G49p1gfy+QQS22ux+6d6A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Bittermann <t.bittermann@online.de>

This patch adds 2 missing symbol exports:

jiffies_to_timeval
timeval_to_jiffies

Signed-off-by: Thomas Bittermann <t.bittermann@online.de>
---
 kernel/time.c |    2 ++
 1 file changed, 2 insertions(+)
Index: linux-2.6.21-rc5.fix/kernel/time.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/time.c 2007-04-04 21:39:02.000000000 +0200
+++ linux-2.6.21-rc5.fix/kernel/time.c  2007-04-04 21:39:14.000000000 +0200
@@ -635,6 +635,7 @@ timeval_to_jiffies(const struct timeval
                (((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
                 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 }
+EXPORT_SYMBOL(timeval_to_jiffies);

 void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 {
@@ -649,6 +650,7 @@ void jiffies_to_timeval(const unsigned l
        tv_usec /= NSEC_PER_USEC;
        value->tv_usec = tv_usec;
 }
+EXPORT_SYMBOL(jiffies_to_timeval);

 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
