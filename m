Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYKDWvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYKDWvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbYKDWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:50:28 -0500
Received: from xenotime.net ([72.52.64.118]:34709 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755510AbYKDWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:50:26 -0500
Message-ID: <4910CEA5.1050501@xenotime.net>
Date: Tue, 04 Nov 2008 14:37:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] documentation: update scheduler header file paths
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update Documentation/scheduler/ files to reflect changed header files locations.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/scheduler/sched-arch.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lin2628-rc3.orig/Documentation/scheduler/sched-arch.txt
+++ lin2628-rc3/Documentation/scheduler/sched-arch.txt
@@ -8,7 +8,7 @@ Context switch
 By default, the switch_to arch function is called with the runqueue
 locked. This is usually not a problem unless switch_to may need to
 take the runqueue lock. This is usually due to a wake up operation in
-the context switch. See include/asm-ia64/system.h for an example.
+the context switch. See arch/ia64/include/asm/system.h for an example.
 
 To request the scheduler call switch_to with the runqueue unlocked,
 you must `#define __ARCH_WANT_UNLOCKED_CTXSW` in a header file
@@ -23,7 +23,7 @@ disabled. Interrupts may be enabled over
 introduce a significant interrupt latency by adding the line
 `#define __ARCH_WANT_INTERRUPTS_ON_CTXSW` in the same place as for
 unlocked context switches. This define also implies
-`__ARCH_WANT_UNLOCKED_CTXSW`. See include/asm-arm/system.h for an
+`__ARCH_WANT_UNLOCKED_CTXSW`. See arch/arm/include/asm/system.h for an
 example.
 
 
