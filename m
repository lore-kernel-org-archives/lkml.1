Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZGHEOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZGHEOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZGHEOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:14:07 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:43329 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZGHEOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:14:05 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 01/12] SFI: Simple Firmware Interface - new MAINTAINERS entry
Date: Wed, 08 Jul 2009 00:13:47 -0400
Message-id: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
In-reply-to: <1247026438-20891-1-git-send-email-lenb@kernel.org>
References: <1247026438-20891-1-git-send-email-lenb@kernel.org>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

CONFIG_SFI=y shall enable the kernel to boot and run optimally
on platforms that support the Simple Firmware Interface.

Thanks to Jacob Pan for prototyping the initial Linux SFI support,
and to Feng Tang for Linux bring-up and debug both in emulation
and on Moorestown hardware.

See http://simplefirmware.org for more information on SFI.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 381190c..2c03d31 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5298,6 +5298,18 @@ L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	drivers/pci/hotplug/shpchp*
 
+SIMPLE FIRMWARE INTERFACE (SFI)
+P:	Len Brown
+M:	lenb@kernel.org
+L:	sfi-devel@simplefirmware.org
+W:	http://simplefirmware.org/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git
+S:	Supported
+F:	arch/x86/kernel/*sfi*
+F:	drivers/sfi/
+F:	include/linux/sfi*.h
+
+
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
 P:	Vincent Sanders
-- 
1.6.0.6

