Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYKVRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYKVRoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYKVRnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:43:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46526 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759571AbYKVRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:43:30 -0500
To: davem@davemloft.net
Subject: [PATCH 25/32] pdev_to_pnode() is used from __devinit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wW1-00074n-3Y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:43:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/pcic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -436,7 +436,7 @@ int pcic_present(void)
 	return pcic0_up;
 }
 
-static int __init pdev_to_pnode(struct linux_pbm_info *pbm, 
+static int __devinit pdev_to_pnode(struct linux_pbm_info *pbm, 
 				    struct pci_dev *pdev)
 {
 	struct linux_prom_pci_registers regs[PROMREG_MAX];
