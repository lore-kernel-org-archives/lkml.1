Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZGHEPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZGHEPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbZGHEOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:31 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:46912 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZGHEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:08 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 03/12] SFI: document boot param "sfi=off"
Date: Wed, 08 Jul 2009 00:13:49 -0400
Message-id: <57dac60d76c191e3bd72f186833fac01e4c5f8f1.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
In-reply-to: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

"sfi=off" is analogous to "acpi=off"

In practice, "sfi=off" isn't likely to be very useful, for
1. SFI is used only when ACPI is not available
2. Today's SFI systems are not legacy PC-compatible

ie. "sfi=off" on an ACPI-platform is a NO-OP,
and "sfi=off" on an SFI-platform will likely result in boot failure.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d77fbd8..68337e6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -92,6 +92,7 @@ parameter is applicable:
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
 	SERIAL	Serial support is enabled.
+	SFI	Simple Firmware Interface
 	SH	SuperH architecture is enabled.
 	SMP	The kernel is an SMP kernel.
 	SPARC	Sparc architecture is enabled.
@@ -2162,6 +2163,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			If enabled at boot time, /selinux/disable can be used
 			later to disable prior to initial policy load.
 
+	sfi=		[SFI,X86] Simple Firmware Interface
+			Format: { "off" }
+			off -- disable SFI
+
 	serialnumber	[BUGS=X86-32]
 
 	shapers=	[NET]
-- 
1.6.0.6

