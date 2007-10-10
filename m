Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXJJPuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXJJPuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbXJJPuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:50:39 -0400
Received: from rrcs-64-183-102-10.west.biz.rr.com ([64.183.102.10]:37535 "EHLO
	jg555.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755650AbXJJPuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:50:39 -0400
Message-ID: <470CF4C4.7030509@jg555.com>
Date: Wed, 10 Oct 2007 08:50:28 -0700
From: Jim Gifford <maillist@jg555.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Nvidia SATA - Seagate SATA Drives
References: <fa.d5rGdIs30c4F+oG0m3Si2DyLz24@ifi.uio.no> <470C6949.5050806@shaw.ca> <470CE2F9.8020206@jg555.com> <470CEC25.1040209@shaw.ca>
In-Reply-To: <470CEC25.1040209@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Jim Gifford wrote:
>> Robert Hancock wrote:
>>> Jim Gifford wrote:
>>>> Here's the situation. I have a MSI KN8Neo-f motherboard with a 
>>>> Seagate Barracuda 250 GB SATA drive. I have replaced this drive 
>>>> three times in the last two weeks due to it failing. Now the only 
>>>> thing in common is the use of a 2.6.22.9 kernel I built from 
>>>> scratch, before that I was using 2.6.19 kernel but working on doing 
>>>> some upgrades for the CLFS project and tried a 2.6.22.9.  I will 
>>>> explain the situation and including the links I used for fix the 
>>>> issues.
>>>>
>>>> It boots up and instantly has a problem detecting so I have to add 
>>>> irqpoll to my bootup line. {Reference 
>>>> http://my.opera.com/snowburn/blog/index.dml/tag/failed%20to%20set%20xfermode} 
>>>> Then I get the adma issue, so I add sata_nv.adma=0 to my bootup 
>>>> line.{Reference 
>>>> http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/1424.html}
>>>>
>>>> Now after a few times of booting the drive completely fails. So is 
>>>> the nv_sata drive the cause?? Based on what I have done yes, and 
>>>> the reason I can say that is because I took another one of those 
>>>> drives and the same computer loaded Windows(forgive me for using 
>>>> this word!!!) on it and it worked perfectly.
>>>
>>> You'll have to be more specific about "completely fails".. Also, it 
>>> would be useful to get the dmesg output from dmesg directly and not 
>>> from syslog, as the entries posted under the second link you gave 
>>> were missing some critical information (it seems that syslog can do 
>>> this in some cases..) In particular the line showing what command 
>>> failed would be useful.
>> It never gets into the system at all, just locks up. The hard drive 
>> starts clicking and eventually doesn't get recognized by BIOS.
>
> That doesn't sound like a kernel problem if it's not even recognized 
> by the BIOS, there's nothing the kernel should be able to do that 
> could cause that. Sounds more like a hardware issue. If the drive has 
> been replaced before then it could be a power supply or temperature 
> problem?
I thought that also, just tried a new power supply, same problem. I can 
recreate this problem within minutes with a new drive. Got 2 more drives 
left in this batch. Temperature is in the low range of the specs.
