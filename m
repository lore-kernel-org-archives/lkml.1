Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbXI0ROE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbXI0ROE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbXI0RNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:13:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbXI0RNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:13:54 -0400
Message-ID: <46FBE478.6040602@redhat.com>
Date: Thu, 27 Sep 2007 13:12:24 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       konradr@redhat.com, konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net> <20070926142950.46bbfcd2.randy.dunlap@oracle.com> <200709262052.44845.konrad@darnok.org> <46FBE30D.7010108@zytor.com>
In-Reply-To: <46FBE30D.7010108@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Konrad Rzeszutek wrote:
>>>> +config ISCSI_IBFT
>>>> +	tristate "iSCSI Boot Firmware Table Attributes"
>>>> +	depends on X86
>>> why only on X86?
>> PowerPC exports this data via the OpenFirmware so it already shows in 
>> the /sysfs entries. I was thinking to combine those sysfs entries under this 
>> code, but that is something in the future.
>>
>> In regards to all other platforms, I figured I would only make it supported 
>> under platforms that have been tested. Is there anything that stops this from 
>> working for example of IA64? Well no. The hardware that supports the iBFT is 
>> either in the BIOS or in NICs - so the SGI or HP boxes _should_ work, however 
>> I am not comfortable to make it supported unless I've tested it.
>>
> 
> It should, presumably, depend on ACPI, rather than on X86...?

Actually no.  That /should/ be the correct answer, but none of the 
hardware vendors actually provide the table via ACPI yet.  Also, if they 
did, the support for /sys/firmware/acpi/tables/* would be sufficient 
instead of having this code *at all*.

-- 
   Peter
