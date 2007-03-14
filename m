Return-Path: <linux-kernel-owner+w=401wt.eu-S1030758AbXCNJRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030758AbXCNJRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030755AbXCNJRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:17:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60779 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740AbXCNJQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:16:55 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 12/13] rtc-cmos needs RTC_ALWAYS_BCD known
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPbK-0003Gn-Of@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:16:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-m68k/mc146818rtc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-m68k/mc146818rtc.h b/include/asm-m68k/mc146818rtc.h
index 11fe12d..9f70a01 100644
--- a/include/asm-m68k/mc146818rtc.h
+++ b/include/asm-m68k/mc146818rtc.h
@@ -11,6 +11,7 @@
 #include <asm/atarihw.h>
 
 #define RTC_PORT(x)	(TT_RTC_BAS + 2*(x))
+#define RTC_ALWAYS_BCD	0
 
 #define CMOS_READ(addr) ({ \
 atari_outb_p((addr),RTC_PORT(0)); \
-- 
1.5.0-rc2.GIT


