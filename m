Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYLDBAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYLDBAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYLDBAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:00:19 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:62933 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYLDBAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:00:18 -0500
Date: Thu, 4 Dec 2008 09:00:13 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: mingo@redhat.com
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: fix warning of uninitialized variable
Message-ID: <20081204010013.GA17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix warning of uninitialized 'base' in arch/x86/kernel/scx200_32.c

arch/x86/kernel/scx200_32.c: In function ‘scx200_probe’:
arch/x86/kernel/scx200_32.c:82: warning: ‘base’ may be used
uninitialized in this function

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 arch/x86/kernel/scx200_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 7e004ac..e9e3a24 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -58,7 +58,7 @@ static void __devinit scx200_init_shadow(void)
 
 static int __devinit scx200_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	unsigned base;
+	unsigned base = 0;
 
 	if (pdev->device == PCI_DEVICE_ID_NS_SCx200_BRIDGE ||
 	    pdev->device == PCI_DEVICE_ID_NS_SC1100_BRIDGE) {
-- 
1.5.6.3

-- 
Jianjun Kong | Happy Hacking
HOMEPAGE: http://kongove.cn/
GTALK: kongjianjun@gmail.com
