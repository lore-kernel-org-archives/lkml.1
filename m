Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbYKVRl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbYKVRl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbYKVRhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:37:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997AbYKVRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:37:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 26/32] enable_IR_x2apic() needs to be __init
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wQI-0006cs-MI@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:37:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


calls __init, called only from __init

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/kernel/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1315,7 +1315,7 @@ void enable_x2apic(void)
 	}
 }
 
-void enable_IR_x2apic(void)
+void __init enable_IR_x2apic(void)
 {
 #ifdef CONFIG_INTR_REMAP
 	int ret;
