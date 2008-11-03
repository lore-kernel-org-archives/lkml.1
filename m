Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbYKCIVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbYKCIVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYKCIV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:21:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbYKCIV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:21:29 -0500
Message-ID: <490EB3D7.6060605@cn.fujitsu.com>
Date: Mon, 03 Nov 2008 16:18:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] update 'isolcpus' kernel option
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset can be used to move a process onto or off an isolated CPU.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1bbcaa8..8a8cb0c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -995,13 +995,15 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<cpu number>,...,<cpu number>
 			or
-			<cpu number>-<cpu number>  (must be a positive range in ascending order)
+			<cpu number>-<cpu number>
+			(must be a positive range in ascending order)
 			or a mixture
 			<cpu number>,...,<cpu number>-<cpu number>
+
 			This option can be used to specify one or more CPUs
 			to isolate from the general SMP balancing and scheduling
-			algorithms. The only way to move a process onto or off
-			an "isolated" CPU is via the CPU affinity syscalls.
+			algorithms. You can move a process onto or off an
+			"isolated" CPU via the CPU affinity syscalls or cpuset.
 			<cpu number> begins at 0 and the maximum value is
 			"number of CPUs in system - 1".
 
-- 
1.5.4.rc3

