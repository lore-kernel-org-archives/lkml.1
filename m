Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab0BXVDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:03:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:4253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab0BXVDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:03:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,534,1262592000"; 
   d="scan'208";a="247746163"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Du, Alek" <alek.du@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Wed, 24 Feb 2010 13:03:44 -0800
Subject: RE: [PATCH] x86/pci: exclude mrst pci code for other platform
Thread-Topic: [PATCH] x86/pci: exclude mrst pci code for other platform
Thread-Index: Acq1kZqUu9Q60risRfGBuLs7y1pKEAAApu+A
Message-ID: <43F901BD926A4E43B106BF17856F0755A321EB54@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D01@orsmsx508.amr.corp.intel.com>
 <tip-d39f6495f66616b637260405d0b5dc2656bc490e@git.kernel.org>
 <4B8493A0.6080501@kernel.org> <4B84A846.1000805@kernel.org>
 <4B84AAC4.2020204@kernel.org> <4B858E89.7040807@kernel.org>
In-Reply-To: <4B858E89.7040807@kernel.org>
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

Our goal is to have a binary compatible kernel runs on Moorestown and PC, can
we keep the Moorestown PCI code for this purpose?

>-----Original Message-----
>From: Yinghai Lu [mailto:yinghai@kernel.org]
>Sent: Wednesday, February 24, 2010 12:40 PM
>To: mingo@redhat.com; hpa@zytor.com; tglx@linutronix.de
>Cc: linux-kernel@vger.kernel.org; Du, Alek; Pan, Jacob jun; Siddha, Suresh B;
>Jesse Barnes
>Subject: [PATCH] x86/pci: exclude mrst pci code for other platform
>
>
>
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
>diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
>index ab637f9..131e4da 100644
>--- a/arch/x86/pci/Makefile
>+++ b/arch/x86/pci/Makefile
>@@ -13,7 +13,8 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
>
> obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
>
>-obj-y				+= common.o early.o mrst.o
>+obj-y				+= common.o early.o
>+obj-$(CONFIG_X86_MRST)		+= mrst.o
> obj-y				+= amd_bus.o bus_numa.o
>
> ifeq ($(CONFIG_PCI_DEBUG),y)
