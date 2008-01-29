Return-Path: <linux-kernel-owner+w=401wt.eu-S1765231AbYA2AiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765231AbYA2AiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYA2AiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:38:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:42417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYA2AiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,264,1199692800"; 
   d="scan'208";a="255548091"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Date: Mon, 28 Jan 2008 16:37:12 -0800
Message-ID: <39B20DF628532344BC7A2692CB6AEE0702403B4B@orsmsx420.amr.corp.intel.com>
In-Reply-To: <20080129002133.GA13664@colo.lackof.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Thread-Index: AchiDQbFAPreZJshQE2PtHRDakJLdQAAb/nA
References: <200801281720.37350.jason.d.gaston@intel.com> <20080129002133.GA13664@colo.lackof.org>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Cc: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <khali@linux-fr.org>,
       <i2c@lm-sensors.nu>
X-OriginalArrivalTime: 29 Jan 2008 00:38:07.0523 (UTC) FILETIME=[37800F30:01C8620F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Grant Grundler [mailto:grundler@parisc-linux.org]
>Sent: Monday, January 28, 2008 4:22 PM
>To: Gaston, Jason D
>Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; linux-
>pci@atrey.karlin.mff.cuni.cz; khali@linux-fr.org; i2c@lm-sensors.nu
>Subject: Re: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
>
>On Mon, Jan 28, 2008 at 05:20:36PM -0800, Jason Gaston wrote:
>> This patch adds the Intel ICH10 LPC and SMBus Controller DeviceID's.
>
>Jason,
>two questions:
>Have you submitted these to pciids.sf.net?
>Where are these used in the kernel?
>
>thanks,
>grant
>
>>
>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>
>> --- linux-2.6.24/include/linux/pci_ids.h.orig	2008-01-24
>14:58:37.000000000 -0800
>> +++ linux-2.6.24/include/linux/pci_ids.h	2008-01-28
>15:05:41.000000000 -0800
>> @@ -2339,6 +2339,12 @@
>>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
>>  #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
>> +#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
>> +#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
>> +#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
>> +#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
>> +#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
>> +#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
>>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>>  #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
>>  #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031

Yes, these have been submitted to pciids.sf.net.  I am also in the
process up updating the pci.ids strings by adding "ICH10" to them.  

These pci_ids.h entries are used in the drivers/i2c/busses/i2c-i801.c
driver and the /arch/x86/pci/irq.c file.

Thank you,

Jason
