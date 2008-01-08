Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYAHXbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYAHXbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYAHXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:30:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYAHXat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:30:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Yo8yc1T37y7D8G25GbJ6uDq61eP8OwMjJTdJsICIseiPSREte7mFY5J4pfwIHzAiHE1iqZCZqJVs9lLWr3887hwlklJIAGtn2EkLOEj1Kd9v3mlSeGqgD4ttFuQ1J6CdVSMpoIrX/U34o4mM56VqfRVSEbCYmqX8NAsi2svRo2o=
Date: Wed, 9 Jan 2008 00:31:00 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86: coding style fixes in arch/x86/pci/direct.c
Message-ID: <20080109003100.6d7d6297@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple coding style fixes.
File is now "error" free according to checkpatch.pl


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/pci/direct.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 431c9a5..4eefa5c 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -50,7 +50,7 @@ int pci_conf1_write(unsigned int seg, unsigned int bus,
 {
 	unsigned long flags;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
+	if ((bus > 255) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -102,7 +102,7 @@ static int pci_conf2_read(unsigned int seg, unsigned int bus,
 	dev = PCI_SLOT(devfn);
 	fn = PCI_FUNC(devfn);
 
-	if (dev & 0x10) 
+	if (dev & 0x10)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -135,13 +135,13 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 	unsigned long flags;
 	int dev, fn;
 
-	if ((bus > 255) || (devfn > 255) || (reg > 255)) 
+	if ((bus > 255) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
 	dev = PCI_SLOT(devfn);
 	fn = PCI_FUNC(devfn);
 
-	if (dev & 0x10) 
+	if (dev & 0x10)
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
@@ -161,7 +161,7 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 		break;
 	}
 
-	outb(0, 0xCF8);    
+	outb(0, 0xCF8);
 
 	spin_unlock_irqrestore(&pci_config_lock, flags);
 
-- 
1.5.4.rc2.17.g257f

