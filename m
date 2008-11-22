Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYKVRnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYKVRnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759877AbYKVRi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:38:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58505 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759388AbYKVRiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:38:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 31/32] sn_pci_controller_fixup() should be __init
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wR6-0006g2-N5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:38:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


called only from __init

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/sn/kernel/io_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/io_init.c b/arch/ia64/sn/kernel/io_init.c
--- a/arch/ia64/sn/kernel/io_init.c
+++ b/arch/ia64/sn/kernel/io_init.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(sn_io_slot_fixup);
  * sn_pci_controller_fixup() - This routine sets up a bus's resources
  *			       consistent with the Linux PCI abstraction layer.
  */
-static void
+static void __init
 sn_pci_controller_fixup(int segment, int busnum, struct pci_bus *bus)
 {
 	s64 status = 0;
