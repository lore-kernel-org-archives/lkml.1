Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574Ab0BZRgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:37 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:49258 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965556Ab0BZRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:20 -0500
X-SpamScore: -6
X-BigFish: VPS-6(zz1417J936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7V-02-2M1-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 02/15] oprofile: remove EXPERIMENTAL from the config option description
Date: Fri, 26 Feb 2010 18:29:54 +0100
Message-ID: <1267205407-6523-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0101 (UTC) FILETIME=[216084D0:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OProfile is already used for a long time and no longer experimental.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig |    2 +-
 init/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 25e69f7..d677872 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config OPROFILE
-	tristate "OProfile system profiling (EXPERIMENTAL)"
+	tristate "OProfile system profiling"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
 	select RING_BUFFER
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..b7c5839 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1112,7 +1112,7 @@ config MMAP_ALLOW_UNINITIALIZED
 	  See Documentation/nommu-mmap.txt for more information.
 
 config PROFILING
-	bool "Profiling support (EXPERIMENTAL)"
+	bool "Profiling support"
 	help
 	  Say Y here to enable the extended profiling support mechanisms used
 	  by profilers such as OProfile.
-- 
1.6.6


