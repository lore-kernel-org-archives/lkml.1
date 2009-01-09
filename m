Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZAIGzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZAIGzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZAIGyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:54:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:19070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbZAIGyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,235,1231142400"; 
   d="scan'208";a="655771278"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Dirk Hohndel'" <hohndel@infradead.org>
CC: "'Grant Grundler'" <grundler@parisc-linux.org>,
       "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Arjan van de Ven'" <arjan@infradead.org>
Date: Fri, 9 Jan 2009 14:53:14 +0800
Subject: RE: git-latest: kernel oops in IOMMU setup
Thread-Topic: git-latest: kernel oops in IOMMU setup
Thread-Index: AclyFhdVdcQQKqBWSDKBYIsVsLHQVAADqndw
Message-ID: <715D42877B251141A38726ABF5CABF2C018E8FECAA@pdsmsx503.ccr.corp.intel.com>
References: <20090108120538.0176d348@infradead.org>
	<20090108214116.GB20506@colo.lackof.org>
	<715D42877B251141A38726ABF5CABF2C018E8FEA77@pdsmsx503.ccr.corp.intel.com>
	<20090108180515.2f279671@infradead.org>
 <20090108205222.2c89dcde@infradead.org>
In-Reply-To: <20090108205222.2c89dcde@infradead.org>
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

Dirk Hohndel wrote:
> On Thu, 8 Jan 2009 18:05:15 -0800
> Dirk Hohndel <hohndel@infradead.org> wrote:
> 
>> On Fri, 9 Jan 2009 08:58:46 +0800 "Han, Weidong"
>> 
>> I updated to Linus' latest git (as your description made me wonder if
>> the async stuff might play a role here). I still get an oops - but at
>> a different spot and the system no longer hangs - it partly recovers
>> (but things aren't too well - for example my USB keyboard / mouse
>> don't work anymore).
> 
> Spoke too soon. Rebooted and had the same hard lockup again. This time
> I had my camera within reach, so here's the trace:
> 
> device_to_iommu+0x33/0x73
> domain_context_mapping_one+0x37/0x335
> domain_context_mapping+0x25/0xa7
> iommu_prepare_identity+0xd7/0xf3
> intel_iommu_init+0x4e4/0x8f3
> ? mutex_lock
> ? sysctl_net_init
> ? pci_iommu_init
> pci_iommu_init
> 
> I also have stack, code and register values. Let me know if you need
> them. Or I can just post the picture :-)
> 
> Again, very latest git tree, VT-d enabled.
> 
> /D

I tried latest git tree, it works for me. Above call trace looks right. 

Regards,
Weidong