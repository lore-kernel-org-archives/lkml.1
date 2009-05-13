Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbZEMWPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbZEMWPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbZEMWPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:15:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:34186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbZEMWPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:15:34 -0400
Subject: [PATCH] ia64: msi_ia64.c dmar_msi_type should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242252753.3364.22.camel@localhost.localdomain>
References: <1242252753.3364.22.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 03:43:51 +0530
Message-Id: <1242252831.3364.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/ia64/kernel/msi_ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 0f8ade9..6c89228 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -158,7 +158,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 }
 #endif /* CONFIG_SMP */
 
-struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
-- 
1.6.0.6



