Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbZDRDIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbZDRDIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 23:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZDRDIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 23:08:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:30565 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZDRDIg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 23:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,207,1239001200"; 
   d="scan'208";a="132837309"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>
CC: "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>
Date: Sat, 18 Apr 2009 11:07:57 +0800
Subject: RE: [PATCH 0/5] fix bugs of x2apic/intr-remap
Thread-Topic: [PATCH 0/5] fix bugs of x2apic/intr-remap
Thread-Index: Acm/arBakAElJctrTfOV2RSBV7LKdAAZk3sw
Message-ID: <715D42877B251141A38726ABF5CABF2C01A6B7F4B3@pdsmsx503.ccr.corp.intel.com>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
 <20090417143033.GF23493@elte.hu> <20090417144152.GA11772@elte.hu>
In-Reply-To: <20090417144152.GA11772@elte.hu>
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

Ingo Molnar wrote:
> Note, there's a new compiler warning caused by your patches:
> 
>   arch/x86/kernel/apic/io_apic.c:2543: warning: 'eoi_ioapic_irq'
> defined but not used 
> 
> most likely by:
> 
>   631dd75: x86, intr-remap: fix ack for interrupt remapping
> 
> 	Ingo

eoi_ioapic_irq is only used for remapped interrupt, so we should define eoi_ioapic_irq and __eoi_ioapic_irq when #ifdef CONFIG_INTR_REMAP.

Regards,
Weidong