Return-Path: <linux-kernel-owner+w=401wt.eu-S935080AbZLKXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935080AbZLKXji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935059AbZLKXjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:39:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:57343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934999AbZLKXhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:37:13 -0500
Message-ID: <4B22D746.9040807@kernel.org>
Date: Fri, 11 Dec 2009 15:35:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/7] x86/pci: use u64 instead of size_t in amd_bus.c
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



prepare to enable it for 32bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -82,8 +82,8 @@ static int __init early_fill_mp_bus_info
 	struct pci_root_info *info;
 	u32 reg;
 	struct resource *res;
-	size_t start;
-	size_t end;
+	u64 start;
+	u64 end;
 	struct range range[RANGE_NUM];
 	u64 val;
 	u32 address;

