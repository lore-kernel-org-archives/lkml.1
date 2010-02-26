Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569Ab0BZRhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:37:25 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:41863
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965512Ab0BZRgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:06 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7M-01-R68-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>, stable@kernel.org
Subject: [PATCH 01/15] oprofile: remove tracing build dependency
Date: Fri, 26 Feb 2010 18:29:53 +0100
Message-ID: <1267205407-6523-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0085 (UTC) FILETIME=[215E13D0:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit

 1155de4 ring-buffer: Make it generally available

already made ring-buffer available without the TRACING option
enabled. This patch removes the TRACING dependency from oprofile.

Fixes also oprofile configuration on ia64.

The patch also applies to the 2.6.32-stable kernel.

Reported-by: Tony Jones <tonyj@suse.de>
Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9d055b4..25e69f7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -6,8 +6,6 @@ config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
-	depends on TRACING_SUPPORT
-	select TRACING
 	select RING_BUFFER
 	select RING_BUFFER_ALLOW_SWAP
 	help
-- 
1.6.6


