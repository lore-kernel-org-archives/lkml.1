Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbZEMWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbZEMWNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZEMWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:13:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:33871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZEMWNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:13:04 -0400
Subject: [PATCH-tip] x86: apic/io_apic.c dmar_msi_type should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       x86 maintainers <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 03:42:33 +0530
Message-Id: <1242252753.3364.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 0a3f3ab..f3e16ad 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3538,7 +3538,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 #endif /* CONFIG_SMP */
 
-struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
-- 
1.6.0.6



