Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZAKQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZAKQwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZAKQwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:52:10 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:48203 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAKQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:52:09 -0500
Message-ID: <496A23AC.1090909@oracle.com>
Date: Sun, 11 Jan 2009 08:51:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Korolev <akorolev@infradead.org>
CC: Alexander Beregalov <a.beregalov@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: mtd/lpddr/qinfo_probe.c needs lpddr_cmds to be compiled
References: <20090110021641.GA26951@orion> <49682F42.8070304@oracle.com> <alpine.LFD.2.00.0901110958360.20119@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901110958360.20119@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.496A23AF.0086:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Korolev wrote:
> Hi Randy,
> 
> I've just checked 2.6.29-rc1. It contains LPDDR patches but does not contain this patch. 
> Do you know whom I should ask to make this included?

MAINTAINERS file:

MEMORY TECHNOLOGY DEVICES (MTD)
P:      David Woodhouse
M:      dwmw2@infradead.org

> Thanks,
> Alexey
> 
>>> drivers/built-in.o: In function `lpddr_probe':
>>> drivers/mtd/lpddr/qinfo_probe.c:215:
>>> undefined reference to `lpddr_cmdset'
>>>
>>> # CONFIG_MTD_LPDDR is not set
>>> CONFIG_MTD_QINFO_PROBE=y
>>> --
>> This patch has been posted, just needs to be merged (hint):
>> ---
>>
>>
>> Signed-off-by: Alexey Korolev <akorolev@infradead.org>
>> ---
>> diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
>> index acd4ea9..5a401d8 100644
>> --- a/drivers/mtd/lpddr/Kconfig
>> +++ b/drivers/mtd/lpddr/Kconfig
>> @@ -12,6 +12,7 @@ config MTD_LPDDR
>>  	  DDR memories, intended for battery-operated systems.
>>  
>>  config MTD_QINFO_PROBE
>> +	depends on MTD_LPDDR
>>  	tristate "Detect flash chips by QINFO probe"
>>  	help
>>  	    Device Information for LPDDR chips is offered through the Overlay
>>
>>


-- 
~Randy
