Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZDNDC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZDNDC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZDNDCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:02:47 -0400
Received: from 219-80-62-20.static.tfn.net.tw ([219.80.62.20]:50660 "EHLO
	Thunder.acard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZDNDCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:02:46 -0400
Message-ID: <49E3F4B0.1080909@acard.com>
Date: Tue, 14 Apr 2009 10:28:00 +0800
From: Jim Yeh <jimyeh98@acard.com>
Reply-To: jimyeh98@acard.com
Organization: ACARD Technology Crop.
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: jason wu <jason_wu@acard.com>,
       =?UTF-8?B?IuiOiuaWh+iIiShKYXNvbiBDaHVh?= =?UTF-8?B?bmcpIg==?= 
	<jason@acard.com>,
       =?UTF-8?B?IumZs+WKm+iqoChSaWNoYXI=?= =?UTF-8?B?ZCBDaGVuKSI=?= 
	<rchern@acard.com>,
       =?UTF-8?B?Iue/geiMguizgChEYQ==?= =?UTF-8?B?bmllbCBXZW5nKSI=?= 
	<dweng@acard.com>,
       =?UTF-8?B?IuWQs+S9s+eSiyg=?= =?UTF-8?B?TGF1cmVuY2UgV3UpIg==?= 
	<laurence@acard.com>,
       =?UTF-8?B?IumZs+W+tw==?= =?UTF-8?B?5aiBKERlcndlaSBDaGVuKSI=?= 
	<derwei@acard.com>,
       =?UTF-8?B?IumZsw==?= =?UTF-8?B?6YeR5riFKEdlaW5nQ2hpbmcgQ2hlbiki?= 
	<geingching@acard.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <htejun@gmail.com>
Subject: Re: Fw: [PATCH] ahci: add ACard 8620 support (rough draft)
References: <000d01c9b815$73006700$b500a8c0@JasonWuNB> <49E31219.1000301@acard.com> <49E323E1.90907@garzik.org>
In-Reply-To: <49E323E1.90907@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MAIL: Thunder.acard.com n3E2TPjo050447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jeff,

Thanks for your explanation. We agree with you.

 I'll prepare the hardware for your testing. The form factor of PCB will 
be a 32bit PCI-base add-on card. Please advise the address for both of 
yours. It is expected to be sent by next week.

Regards,
 
Jim Yeh
Product Manager
Marketing Dept.
ACARD Technology Corp.
TEL:886-2-85122290#3244



Jeff Garzik 提到:
> Jim Yeh wrote:
>> Dear Jeff,
>>
>> This is Jim,an IC PM from ACARD Technology. Thanks for your effort on 
>> building Linux driver for ACARD ATP8620. Since ACARD already have a 
>> verified AHCI driver for ATP8620, we'd like to submit this one for 
>> the kernel built-in driver (please see attachment). This driver 
>> support Linux Kernel 2.6.29 AHCI mode for ATP8620 (2ch SATA IC) and 
>> ATP8624 (4ch SATA IC). It already passed our own stability and 
>> compatibility test with SATA devices like HDD, ODD, or 
>> PortMultiplier. If you have any question or need the hardware for 
>> testing, please don't hesitate to contact me. Thanks again for your 
>> help.
>
> Thank you for your email.
>
> We understand you have verified your driver, but it is standard Linux 
> driver policy to avoid code duplication.  Multiple implementations of 
> AHCI drivers implies several negative factors:
>
> * each bug fix must be reviewed across multiple AHCI drivers, to 
> determine if the bug fix must be copied
>
> * non-uniform user experience, depending on AHCI platform
>
> * Shared AHCI code gets much more testing and verification.
>
> * When a hardware vendor's AHCI chip reaches End Of Life, or the 
> company goes out of business, users are not abandoned.
>
> So, for the official Linux kernel drivers that are shipped by Red Hat, 
> Novell/SuSE, Canonical and other vendors, we will need to modify the 
> existing Linux AHCI driver to support ATP8620 and ATP8624.
>
>
> And yes -- test hardware would be greatly appreciated!  If you could 
> send these, that would be appreciated:
>
>     To Tejun Heo
>     ------------
>     1 x ATP8620
>     1 x ATP8624
>
>     To Jeff Garzik
>     --------------
>     1 x ATP8620
>     1 x ATP8624
>
> I assume this is PCI, PCI-X or PCI-Express form factor?
>
> Regards and thanks,
>
>     Jeff
>
>
>
>
>
> __________ Information from ESET NOD32 Antivirus, version of virus 
> signature database 4005 (20090413) __________
>
> The message was checked by ESET NOD32 Antivirus.
>
> http://www.eset.com
>
>
>
>
