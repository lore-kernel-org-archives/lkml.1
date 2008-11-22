Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYKVRmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYKVRmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759859AbYKVRh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:37:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58498 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845AbYKVRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:37:55 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 28/32] xen_setup_vcpu_info_placement() is not init on x86
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wQc-0006do-Mc@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:37:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... so get xen-ops.h in agreement with xen/smp.c

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/xen/xen-ops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -49,7 +49,7 @@ bool xen_vcpu_stolen(int vcpu);
 
 void xen_mark_init_mm_pinned(void);
 
-void __init xen_setup_vcpu_info_placement(void);
+void xen_setup_vcpu_info_placement(void);
 
 #ifdef CONFIG_SMP
 void xen_smp_init(void);
