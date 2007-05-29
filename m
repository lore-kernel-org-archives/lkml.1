Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXE2Wle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXE2Wle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXE2Wl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:41:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:55061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbXE2Wl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:41:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,590,1170662400"; 
   d="scan'208";a="91543916"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.22-rc2] pci_ids: update patch for Intel ICH9M
Date: Tue, 29 May 2007 15:41:23 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE07015B2121@orsmsx420.amr.corp.intel.com>
In-Reply-To: <20070529152545.887fda6c.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.22-rc2] pci_ids: update patch for Intel ICH9M
Thread-Index: AceiQFJcNZ+MOvb1Q3iGwdZ5MTvKFwAAgbcQ
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <stable@kernel.org>
X-OriginalArrivalTime: 29 May 2007 22:41:24.0679 (UTC) FILETIME=[7CAFDD70:01C7A242]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please change them in the 2.6.21.x kernel as well.

Thank you,

Jason


>-----Original Message-----
>From: Andrew Morton [mailto:akpm@linux-foundation.org]
>Sent: Tuesday, May 29, 2007 3:26 PM
>To: Gaston, Jason D
>Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; linux-
>pci@atrey.karlin.mff.cuni.cz; stable@kernel.org
>Subject: Re: [PATCH 2.6.22-rc2] pci_ids: update patch for Intel ICH9M
>
>On Fri, 25 May 2007 12:03:31 -0700
>Jason Gaston <jason.d.gaston@intel.com> wrote:
>
>> This patch updates the Intel ICH9M LPC Controller DID's, due to a
>> specification change.
>>
>> Signed-off-by: __Jason Gaston <jason.d.gaston@intel.com>
>>
>> --- linux-2.6.22-rc2/include/linux/pci_ids.h.orig	2007-05-25
>> 11:42:11.000000000 -0700
>> +++ linux-2.6.22-rc2/include/linux/pci_ids.h	2007-05-25
>11:43:28.000000000
>> -0700
>> @@ -2266,11 +2266,11 @@
>>  #define PCI_DEVICE_ID_INTEL_ICH8_5	0x283e
>>  #define PCI_DEVICE_ID_INTEL_ICH8_6	0x2850
>>  #define PCI_DEVICE_ID_INTEL_ICH9_0	0x2910
>> -#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2911
>> +#define PCI_DEVICE_ID_INTEL_ICH9_1	0x2917
>>  #define PCI_DEVICE_ID_INTEL_ICH9_2	0x2912
>>  #define PCI_DEVICE_ID_INTEL_ICH9_3	0x2913
>>  #define PCI_DEVICE_ID_INTEL_ICH9_4	0x2914
>> -#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2915
>> +#define PCI_DEVICE_ID_INTEL_ICH9_5	0x2919
>>  #define PCI_DEVICE_ID_INTEL_ICH9_6	0x2930
>>  #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
>>  #define PCI_DEVICE_ID_INTEL_82830_HB	0x3575
>
>I assume we'll need this in 2.6.21.x as well, otherwise those devices
just
>won't work when someone tries to run this kernel on them?
