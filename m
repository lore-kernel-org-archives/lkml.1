Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbYKVRmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbYKVRmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbYKVRhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:37:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58496 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731AbYKVRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:37:45 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 27/32] kvm_setup_secondary_clock() is cpuinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wQS-0006dT-MS@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:37:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/kernel/kvmclock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -128,7 +128,7 @@ static int kvm_register_clock(char *txt)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static void __devinit kvm_setup_secondary_clock(void)
+static void __cpuinit kvm_setup_secondary_clock(void)
 {
 	/*
 	 * Now that the first cpu already had this clocksource initialized,
