Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXI1WKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXI1WKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXI1WKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:10:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:60906 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbXI1WKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,211,1188802800"; 
   d="scan'208";a="235279240"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for Intel Tolapai
Date: Fri, 28 Sep 2007 15:09:16 -0700
Message-ID: <39B20DF628532344BC7A2692CB6AEE0701CF2CA9@orsmsx420.amr.corp.intel.com>
In-Reply-To: <20070831175045.37938669@hyperion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for Intel Tolapai
Thread-Index: Acfr5o3MZUabQFNeTF6FCNXNzjhtzQWNWiEQ
References: <200708302042.59104.jason.d.gaston@intel.com> <20070831175045.37938669@hyperion.delvare>
From: "Gaston, Jason D" <jason.d.gaston@intel.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>, <i2c@lm-sensors.org>
X-OriginalArrivalTime: 28 Sep 2007 22:09:17.0540 (UTC) FILETIME=[366B4A40:01C8021C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jean Delvare [mailto:khali@linux-fr.org]
>Sent: Friday, August 31, 2007 8:51 AM
>To: Gaston, Jason D
>Cc: linux-kernel@vger.kernel.org; gregkh@suse.de; i2c@lm-sensors.org
>Subject: Re: [PATCH 2.6.23-rc4][reRESEND] i2c-i801: SMBus patch for
Intel
>Tolapai
>
>Hi Jason,
>
>On Thu, 30 Aug 2007 20:42:58 -0700, Jason Gaston wrote:
>> Resend with uppercase define.
>>
>> This updated patch adds the Intel Tolapai SMBus Controller DID's.
>> This patch relies on the Tolapai patch to pci_ids.h
>>
>> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
>>
>> --- linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c.orig
2007-08-27
>18:32:35.000000000 -0700
>> +++ linux-2.6.23-rc4/drivers/i2c/busses/i2c-i801.c	2007-08-30
>20:25:10.000000000 -0700
>> @@ -34,6 +34,7 @@
>>      ESB2		269B
>>      ICH8		283E
>>      ICH9		2930
>> +    Tolapai		5032
>>      This driver supports several versions of Intel's I/O Controller
Hubs
>(ICH).
>>      For SMBus support, they are similar to the PIIX4 and are part
>>      of Intel's '810' and other chipsets.
>> @@ -543,6 +544,7 @@
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_17)
},
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_5) },
>>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_6) },
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TOLAPAI_1)
},
>>  	{ 0, }
>>  };
>>
>> @@ -563,6 +565,7 @@
>>  	case PCI_DEVICE_ID_INTEL_ESB2_17:
>>  	case PCI_DEVICE_ID_INTEL_ICH8_5:
>>  	case PCI_DEVICE_ID_INTEL_ICH9_6:
>> +	case PCI_DEVICE_ID_INTEL_TOLAPAI_1:
>>  		isich4 = 1;
>>  		break;
>>  	default:
>
>Applied together with the Documentation patch (no need for a separate
>patch). Note that I will have to wait for Greg to pick the pci_ids.h
>patch before I can push this one.
>
>--
>Jean Delvare

Jean,

The pci_ids.h file is updated in 2.6.23-rc8.  Can you push this
i2c-i801.c patch?

Thanks,

Jason
