Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYHGWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYHGWOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHGWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:14:24 -0400
Received: from mx01.lb01.inode.at ([62.99.145.1]:63881 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752912AbYHGWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:14:23 -0400
X-Greylist: delayed 115716 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 18:14:23 EDT
Message-ID: <489B73B7.4090705@sbg.ac.at>
Date: Fri, 08 Aug 2008 00:14:15 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (X11/20080729)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
References: <4899AF8E.20105@sbg.ac.at> <200808072214.28922.rjw@sisk.pl>	 <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>	 <86802c440808071323o3021a90rae51223187bfd47b@mail.gmail.com> <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>
In-Reply-To: <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Aug 7, 2008 at 1:23 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>   
>> On Thu, Aug 7, 2008 at 1:15 PM, Pallipadi, Venkatesh
>> <venkatesh.pallipadi@intel.com> wrote:
>>     
>>> Adding Yinghai.
>>>
>>>       
>>>> -----Original Message-----
>>>> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>>>> Sent: Thursday, August 07, 2008 1:14 PM
>>>> To: Alexander Huemer
>>>> Cc: linux-kernel@vger.kernel.org; Andi Kleen; Pallipadi, Venkatesh
>>>> Subject: Re: 2.6.27-rc1 mtrr fixes do not work
>>>>
>>>> [Adding CCs.]
>>>>
>>>> On Wednesday, 6 of August 2008, Alexander Huemer wrote:
>>>>         
>>>>> hi,
>>>>>
>>>>> mtrr is wrong on my machine. the fixes of 2.6.27-rc1 do not
>>>>>           
>>>> seem to work.
>>>>         
>>>>> bios is the newest version, mainboard vendor says it's not
>>>>>           
>>>> their fault.
>>>>         
>>>>> mainboard is tyan i5000pw.
>>>>> please tell me how i can help and cc me on answers, i am not
>>>>>           
>>>> subscribed.
>>>>         
>>>>> seaburg ~ # cat /proc/mtrr
>>>>> reg00: base=0x00000000 (   0MB), size=198656MB: write-back, count=1
>>>>> reg01: base=0x80000000 (2048MB), size=197632MB: write-back, count=1
>>>>> reg02: base=0x100000000 (4096MB), size=197632MB: write-back, count=1
>>>>>           
>>>>> seaburg ~ # zcat /proc/config.gz | grep MTRR
>>>>> CONFIG_MTRR=y
>>>>> CONFIG_MTRR_SANITIZER=y
>>>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>>>> seaburg ~ # uname -a
>>>>> Linux seaburg 2.6.27-rc1-blackbit #3 SMP Wed Aug 6 00:34:51 CEST 2008
>>>>> x86_64 Intel(R) Xeon(R) CPU E5420 @ 2.50GHz GenuineIntel GNU/Linux
>>>>> seaburg ~ #
>>>>>           
>> alexander,
>>
>> please send out
>> dmesg -s 262144 > dmesg.txt
>> or
>> dmesg -s 524288 > dmesg.txt
>>
>> you may need to set
>> CONFIG_LOG_BUF_SHIFT=19
>>     
>
> without mtrr_gran_size=64m mtrr_chunk_size=1024m on command line
>
> guess mtrr_chunk_size=512m could work
>
> YH
>   
yinghai,

thanks for the response.
i booted with
mtrr_gransize_64m mtrr_chunk_size_512m
mtrr_chunk_size_512m
here are the 2 dmesg outputs:
http://xx.vu/~ahuemer/dmesg_1.txt
http://xx.vu/~ahuemer/dmesg_2.txt
