Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0CLIfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:35:25 -0500
Received: from mail-pz0-f194.google.com ([209.85.222.194]:56299 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab0CLIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:35:24 -0500
From: Arun Bhanu <arun@bhanu.net>
To: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>, Arun Bhanu <arun@bhanu.net>
Subject: [PATCH] microblaze: Fix Makefile to delete build generated files
Date: Fri, 12 Mar 2010 16:36:56 +0800
Message-Id: <1268383016-18270-1-git-send-email-arun@bhanu.net>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make mrproper' does not to delete the following build generated files:
       arch/microblaze/boot/linux.bin.ub
       arch/microblaze/boot/simpleImage.system
       arch/microblaze/boot/simpleImage.system.ub

Fix the Makefile to delete these build generated files.

Signed-off-by: Arun Bhanu <arun@bhanu.net>
---
 arch/microblaze/boot/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
index 902cf98..73a3263 100644
--- a/arch/microblaze/boot/Makefile
+++ b/arch/microblaze/boot/Makefile
@@ -62,6 +62,6 @@ quiet_cmd_dtc = DTC     $@
 $(obj)/%.dtb: $(dtstree)/%.dts FORCE
 	$(call if_changed,dtc)
 
-clean-kernel += linux.bin linux.bin.gz simpleImage.*
+clean-kernel += linux.bin linux.bin.gz
 
-clean-files += *.dtb simpleImage.*.unstrip
+clean-files += *.dtb *.ub simpleImage.*
-- 
1.6.2.5

