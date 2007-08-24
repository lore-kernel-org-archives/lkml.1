Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXHXQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXHXQjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXHXQjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:39:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:42242 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbXHXQjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="283437808"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 -mm 3/7] I/OAT: code cleanup from checkpatch output
Date: Fri, 24 Aug 2007 09:39:06 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02EB51B9@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070823223833.65fba17e.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 -mm 3/7] I/OAT: code cleanup from checkpatch output
thread-index: AcfmERoUmxyFSUTsToS2vCfax+9jJAAWj4iQ
References: <20070824001335.16997.79665.stgit@localhost.localdomain><20070824001506.16997.43452.stgit@localhost.localdomain> <20070823223833.65fba17e.randy.dunlap@oracle.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>
X-OriginalArrivalTime: 24 Aug 2007 16:39:06.0462 (UTC) FILETIME=[49A36FE0:01C7E66D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>Sent: Thursday, August 23, 2007 10:39 PM
>To: Nelson, Shannon
>Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
>davem@davemloft.net
>Subject: Re: [PATCH v2 -mm 3/7] I/OAT: code cleanup from 
>checkpatch output
>
>On Thu, 23 Aug 2007 17:15:06 -0700 Shannon Nelson wrote:
>
>> Take care of a bunch of little code nits in ioatdma files
>> 
>> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> ---
>> 
>>  drivers/dma/ioat_dma.c |  200 
>+++++++++++++++++++++++++++---------------------
>>  1 files changed, 111 insertions(+), 89 deletions(-)
>> 
>> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
>> index 55227d4..9a4d154 100644
>> --- a/drivers/dma/ioat_dma.c
>> +++ b/drivers/dma/ioat_dma.c
>
>> -	printk(KERN_INFO "Intel(R) I/OAT DMA Engine found, %d
channels\n",
>> -		device->common.chancnt);
>> +	printk(KERN_INFO " "
>> +		 "ioatdma: Intel(R) I/OAT DMA Engine found, %d
channels\n",
>> +		 device->common.chancnt);
>>  
>>  	err = ioat_self_test(device);
>>  	if (err)
>
>> @@ -764,7 +784,8 @@ err_set_dma_mask:
>>  	pci_disable_device(pdev);
>>  err_enable_device:
>>  
>> -	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization
failed\n");
>> +	printk(KERN_INFO " "
>> +		"ioatdma: Intel(R) I/OAT DMA Engine initialization
failed\n");
>>  
>>  	return err;
>>  }
>
>What's with these (KERN_INFO " "
>			"...more strings");
>??

These are admittedly not the smartest move, but they are replaced later
in the patch-set.
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
