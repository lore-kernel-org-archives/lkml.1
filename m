Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYDHJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYDHJtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYDHJtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:49:08 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49440 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590AbYDHJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:49:07 -0400
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: nitingupta910@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] compcache: documentation
Date: Tue, 8 Apr 2008 15:06:49 +0530
User-Agent: KMail/1.9.9
Cc: linux-mm@kvack.org
References: <200804081459.27382.nitingupta910@gmail.com>
In-Reply-To: <200804081459.27382.nitingupta910@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081506.49931.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compcache usage documentation.

Signed-off-by: Nitin Gupta <nitingupta910 at gmail dot com>
---
 Documentation/compcache.txt |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Documentation/compcache.txt b/Documentation/compcache.txt
new file mode 100644
index 0000000..2500da6
--- /dev/null
+++ b/Documentation/compcache.txt
@@ -0,0 +1,29 @@
+
+compcache: Compressed RAM based swap device
+-------------------------------------------
+
+Project home: http://code.google.com/p/compcache
+
+* Introduction
+This is a RAM based block device which acts as swap disk.
+Pages swapped to this device are compressed and stored in
+memory itself.
+
+It uses these components:
+ - TLSF: memory allocator
+ - LZO: de/compressor
+
+* Usage
+ - modprobe compcache compcache_size_kbytes=<size>
+   (If no size is specified, default size of 25% of RAM is taken).
+ - swapon /dev/ramzswap0
+
+* Notes
+ - Allocator and compcache statistics are exported via /proc interface:
+   (if stats are enabled for corresponding modules)
+   - /proc/tlsfinfo (from tlsf.ko)
+   - /proc/compcache (from compcache.ko)
+
+
+Nitin Gupta
+(nitingupta910@gmail.com)
