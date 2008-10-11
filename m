Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYJKGhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYJKGhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYJKGgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:36:49 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52117 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYJKGgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:48 -0400
Date: Sat, 11 Oct 2008 02:35:21 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 01/85] ACPI: Add missing acpi.debug_layer Documentation hunk
 from Thomas Renninger
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Message-id: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/kernel-parameters.txt |   47 ++++++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..44d1bd1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -217,20 +217,39 @@ and is between 256 and 4096 characters. It is defined in the file
 	acpi.debug_level=	[HW,ACPI]
 			Format: <int>
 			Each bit of the <int> indicates an ACPI debug level,
-			1: enable, 0: disable. It is useful for boot time
-			debugging. After system has booted up, it can be set
-			via /sys/module/acpi/parameters/debug_level.
-			CONFIG_ACPI_DEBUG must be enabled for this to produce any output.
-			Available bits (add the numbers together) to enable different
-			debug output levels of the ACPI subsystem:
-			0x01 error 0x02 warn 0x04 init 0x08 debug object
-			0x10 info 0x20 init names 0x40 parse 0x80 load
-			0x100 dispatch 0x200 execute 0x400 names 0x800 operation region
-			0x1000 bfield 0x2000 tables 0x4000 values 0x8000 objects
-			0x10000 resources 0x20000 user requests 0x40000 package.
-			The number can be in decimal or prefixed with 0x in hex.
-			Warning: Many of these options can produce a lot of
-			output and make your system unusable. Be very careful.
+			which corresponds to the level in an ACPI_DEBUG_PRINT
+			statement.  After system has booted up, this mask
+			can be set via /sys/module/acpi/parameters/debug_level.
+
+			CONFIG_ACPI_DEBUG must be enabled for this to produce
+			any output.  The number can be in decimal or prefixed
+			with 0x in hex.  Some of these options produce so much
+			output that the system is unusable.
+
+			The following global components are defined by the
+			ACPI CA:
+			       0x01 error
+			       0x02 warn
+			       0x04 init
+			       0x08 debug object
+			       0x10 info
+			       0x20 init names
+			       0x40 parse
+			       0x80 load
+			      0x100 dispatch
+			      0x200 execute
+			      0x400 names
+			      0x800 operation region
+			     0x1000 bfield
+			     0x2000 tables
+			     0x4000 values
+			     0x8000 objects
+			    0x10000 resources
+			    0x20000 user requests
+			    0x40000 package
+ 			The number can be in decimal or prefixed with 0x in hex.
+ 			Warning: Many of these options can produce a lot of
+ 			output and make your system unusable. Be very careful.
 
 	acpi_pm_good	[X86-32,X86-64]
 			Override the pmtimer bug detection: force the kernel
-- 
1.5.5.1

