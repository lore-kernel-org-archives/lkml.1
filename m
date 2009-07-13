Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZGMMTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZGMMTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbZGMMTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:19:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49623 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbZGMMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:19:13 -0400
Date: Mon, 13 Jul 2009 14:19:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: [PATCH] Remove some very outdated recommendations in
	Documentation/memory.txt
Message-ID: <20090713121911.GA31442@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some very outdated recommendations in Documentation/memory.txt

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/memory.txt |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

Index: linux-2.6.31-rc1-ak/Documentation/memory.txt
===================================================================
--- linux-2.6.31-rc1-ak.orig/Documentation/memory.txt
+++ linux-2.6.31-rc1-ak/Documentation/memory.txt
@@ -1,18 +1,7 @@
 There are several classic problems related to memory on Linux
 systems.
 
-	1) There are some buggy motherboards which cannot properly 
-	   deal with the memory above 16MB.  Consider exchanging
-	   your motherboard.
-
-	2) You cannot do DMA on the ISA bus to addresses above
-	   16M.  Most device drivers under Linux allow the use
-           of bounce buffers which work around this problem.  Drivers
-	   that don't use bounce buffers will be unstable with
-	   more than 16M installed.  Drivers that use bounce buffers
-	   will be OK, but may have slightly higher overhead.
-	
-	3) There are some motherboards that will not cache above
+	1) There are some motherboards that will not cache above
 	   a certain quantity of memory.  If you have one of these
 	   motherboards, your system will be SLOWER, not faster
 	   as you add more memory.  Consider exchanging your 
@@ -24,7 +13,7 @@ It can also tell Linux to use less memor
 If you use "mem=" on a machine with PCI, consider using "memmap=" to avoid
 physical address space collisions.
 
-See the documentation of your boot loader (LILO, loadlin, etc.) about
+See the documentation of your boot loader (LILO, grub, loadlin, etc.) about
 how to pass options to the kernel.
 
 There are other memory problems which Linux cannot deal with.  Random
@@ -42,19 +31,3 @@ Try:
 	  with the vendor. Consider testing it with memtest86 yourself.
 	
 	* Exchanging your CPU, cache, or motherboard for one that works.
-
-	* Disabling the cache from the BIOS.
-
-	* Try passing the "mem=4M" option to the kernel to limit
-	  Linux to using a very small amount of memory. Use "memmap="-option
-	  together with "mem=" on systems with PCI to avoid physical address
-	  space collisions.
-
-
-Other tricks:
-
-	* Try passing the "no-387" option to the kernel to ignore
-	  a buggy FPU.
-
-	* Try passing the "no-hlt" option to disable the potentially
-          buggy HLT instruction in your CPU.
