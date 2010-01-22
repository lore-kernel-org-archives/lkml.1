Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998Ab0AVO4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0AVO4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673Ab0AVOzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:31 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:5524 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942Ab0AVOz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:28 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFI-02-1LB-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/12] perf/core: correct files in MAINTAINERS entry
Date: Fri, 22 Jan 2010 15:21:56 +0100
Message-ID: <1264170127-17402-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0330 (UTC) FILETIME=[DC03E420:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This corrects the file entries for perf_events. The following files
are catched now:

 arch/frv/include/asm/perf_event.h
 arch/frv/lib/perf_event.c
 arch/parisc/include/asm/perf_event.h
 arch/powerpc/include/asm/perf_event.h
 arch/powerpc/kernel/perf_callchain.c
 arch/powerpc/kernel/perf_event.c
 arch/s390/include/asm/perf_event.h
 arch/sh/include/asm/perf_event.h
 arch/sh/kernel/cpu/sh4a/perf_event.c
 arch/sh/kernel/cpu/sh4/perf_event.c
 arch/sh/kernel/perf_callchain.c
 arch/sh/kernel/perf_event.c
 arch/sparc/include/asm/perf_event.h
 arch/sparc/kernel/perf_event.c
 arch/x86/include/asm/perf_event.h
 arch/x86/kernel/cpu/perf_event.c
 include/linux/perf_event.h
 kernel/perf_event.c
 tools/perf/

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..350efc3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4224,7 +4224,9 @@ M:	Ingo Molnar <mingo@elte.hu>
 S:	Supported
 F:	kernel/perf_event.c
 F:	include/linux/perf_event.h
-F:	arch/*/*/kernel/perf_event.c
+F:	arch/*/kernel/perf_event.c
+F:	arch/*/kernel/*/perf_event.c
+F:	arch/*/kernel/*/*/perf_event.c
 F:	arch/*/include/asm/perf_event.h
 F:	arch/*/lib/perf_event.c
 F:	arch/*/kernel/perf_callchain.c
-- 
1.6.6


