Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbXK0RSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbXK0RSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbXK0RSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:18:09 -0500
Received: from smtp.citrix.com ([66.165.176.89]:43258 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020AbXK0RSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:18:08 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Nov 2007 12:18:08 EST
X-SBRS: None
X-MesageID: 32537953
X-Ironport-Server: ftlpip01.citrite.net
X-Remote-IP: 70.42.232.150
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.23,220,1194238800"; 
   d="scan'208";a="32537953"
Date: Tue, 27 Nov 2007 17:08:20 +0000
From: Samuel Thibault <samuel.thibault@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] Alpha and x86_64 don't use socketcall
Message-ID: <20071127170820.GG4197@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@citrix.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alpha and x86_64 architectures don't use socketcall and don't provide
__NR_socketcall.

Signed-off-by: Samuel Thibault <samuel.thibault@citrix.com>

diff -r 51b2b0d0921c include/asm-alpha/unistd.h
--- a/include/asm-alpha/unistd.h	Wed Nov 21 09:41:11 2007 +0000
+++ b/include/asm-alpha/unistd.h	Tue Nov 27 16:40:02 2007 +0000
@@ -573,7 +573,6 @@ type name (type1 arg1,type2 arg2,type3 a
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
-#define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_OLD_GETRLIMIT
diff -r 51b2b0d0921c include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h	Wed Nov 21 09:41:11 2007 +0000
+++ b/include/asm-x86_64/unistd.h	Tue Nov 27 16:40:02 2007 +0000
@@ -648,7 +648,6 @@ do { \
 #define __ARCH_WANT_SYS_SIGNAL
 #define __ARCH_WANT_SYS_UTIME
 #define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
 #define __ARCH_WANT_SYS_FADVISE64
 #define __ARCH_WANT_SYS_GETPGRP
 #define __ARCH_WANT_SYS_LLSEEK
