Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab0BYAlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 19:41:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:1140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572Ab0BYAlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 19:41:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,535,1262592000"; 
   d="scan'208";a="495408465"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Du, Alek" <alek.du@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>
Date: Wed, 24 Feb 2010 16:41:37 -0800
Subject: [PATCH] x86/mrst: add dependencies for Moorestown
Thread-Topic: [PATCH] x86/mrst: add dependencies for Moorestown
Thread-Index: Acq1otQfTLXcxnbeRfy0aHsYNKHfVgAEDpug
Message-ID: <43F901BD926A4E43B106BF17856F0755A321EDE5@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
 <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org>
 <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org>
 <4B84AAC4.2020204@kernel.org> <4B858E89.7040807@kernel.org>
 <43F901BD926A4E43B106BF17856F0755A321EB54@orsmsx508.amr.corp.intel.com>
 <4B859DD1.601@zytor.com> <4B85A3C1.3030903@kernel.org>
 <4B85A8B8.3000608@zytor.com> <4B85AB6C.8000500@kernel.org>
In-Reply-To: <4B85AB6C.8000500@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown platform depends on IOAPIC, specify dependency correctly.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0ab2dce..b50788d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -388,8 +388,10 @@ config X86_ELAN
 
 config X86_MRST
        bool "Moorestown MID platform"
+	depends on PCI_IOAPIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
+	depends on X86_IO_APIC
 	select APB_TIMER
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
-- 
1.5.6.5

