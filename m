Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXKFQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXKFQkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXKFQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:40:38 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:52403 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbXKFQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:40:38 -0500
Date: Tue, 6 Nov 2007 11:38:52 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, matthew@wil.cx
Subject: [PATCH] Add the macro to test if "exactly_one_bit_set" to log2.h.
Message-ID: <Pine.LNX.4.64.0711061135310.23545@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While this macro is defined in terms of "is_power_of_2" and is
therefore functionally equivalent, the visual semantics are sometimes
more appropriate for what is actually being tested.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/log2.h b/include/linux/log2.h
index c8cf5e8..d0d324e 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -55,6 +55,12 @@ bool is_power_of_2(unsigned long n)
 }

 /*
+ *  And for folks who want slightly different semantics ...
+ */
+
+#define exactly_one_bit_set is_power_of_2
+
+/*
  * round up to nearest power of two
  */
 static inline __attribute__((const))
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
