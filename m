Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0BXUkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:40:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:54056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab0BXUkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:40:51 -0500
Message-ID: <4B858E89.7040807@kernel.org>
Date: Wed, 24 Feb 2010 12:39:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, alek.du@intel.com, jacob.jun.pan@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86/pci: exclude mrst pci code for other platform
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com> <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org> <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org> <4B84AAC4.2020204@kernel.org>
In-Reply-To: <4B84AAC4.2020204@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index ab637f9..131e4da 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -13,7 +13,8 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
-obj-y				+= common.o early.o mrst.o
+obj-y				+= common.o early.o
+obj-$(CONFIG_X86_MRST)		+= mrst.o
 obj-y				+= amd_bus.o bus_numa.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
