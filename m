Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbZJNTr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbZJNTr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759710AbZJNTr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525AbZJNTrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:47:25 -0400
Message-ID: <4AD62B52.9060200@redhat.com>
Date: Wed, 14 Oct 2009 15:49:38 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, kaneshige.kenji@jp.fujitsu.com,
       matthew@wil.cx
Subject: Re: GT/s vs Gbps for PCIe bus speed
References: <4AD58EEE.4070405@redhat.com> <m3ljjdstbb.fsf@intrepid.localdomain>
In-Reply-To: <m3ljjdstbb.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Stefan Assmann <sassmann@redhat.com> writes:
> 
>> IMHO this is rather confusing, as most people don't know what GT/s means.
> 
> It's trivial to look it up, isn't it?
> 
>> So I'd suggest the following change:
>>
>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>> @@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
>>  	"66 MHz PCIX 533",	/* 0x11 */
>>  	"100 MHz PCIX 533",	/* 0x12 */
>>  	"133 MHz PCIX 533",	/* 0x13 */
>> -	"2.5 GT/s PCI-E",	/* 0x14 */
>> -	"5.0 GT/s PCI-E",	/* 0x15 */
>> +	"2.5 Gbps PCI-E",	/* 0x14 */
>> +	"5.0 Gbps PCI-E",	/* 0x15 */
> 
> Isn't it like calling 100BASE-TX a 125 Mb/s? _That_ would be confusing.
> BTW PCI-E can be multi-lane so Mb/s (and even MB/s) don't make sense.
> I guess many people don't know what a MHz is either but we don't say
> 133 MHz = 133 Mbps.

so, maybe the right terms are
 2.5 GHz PCI-E
 5.0 GHz PCI-E

No matter how many lanes, or how the data is sent (long or short bursts),
the frequency rate is a constant.

So, the data rate is not stated, just the cycle rate.
This would follow the PCIX syntax as well, which is
void of bandwidth illusions.

- Don

ps -- "GT/s" isn't even defined in the PCIe spec, just
      blindly introduced, and unjustified in its use.
      ..... too much marketing-speak in PCI SIG ...

