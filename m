Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbYAaG7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbYAaG7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 01:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYAaG7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 01:59:22 -0500
Received: from relay1.bcons.ru ([77.105.137.253]:57512 "EHLO relay1.bcons.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752899AbYAaG7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 01:59:22 -0500
Message-ID: <47A171C5.7030100@b-k.ru>
Date: Thu, 31 Jan 2008 09:59:17 +0300
From: Evgen L <evgen@b-k.ru>
User-Agent: Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.8.1.8) Gecko/20071106 SeaMonkey/1.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: intel ahci problem
References: <47A16E27.2090809@b-k.ru>
In-Reply-To: <47A16E27.2090809@b-k.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Evgen L wrote:
>> Hi all
>>
>> I have a problem with my Intel SR1550 server (S5000PAL motheboard, 
>> SATA/SAS controller, 5 SATA HDD Seagate ST9120822AS ).
>> The four drivers are in two md raid1, which striping by lvm and one 
>> drive used separately. I have problem like below with two different 
>> drives (ata3 or ata4) and ata5. I look problem like this with RedHat  
>> 2.6.18-53 kernel, 2.6.24-rc8, and today 2.6.24-git5. I reading about 
>> any problems like this in lkml.org. There can be this message will 
>> help to fix this issue.
>> The complete dmesg in attachment.
>>
>> md: bind<sdd1>
>> RAID1 conf printout:
>> --- wd:1 rd:2
>> disk 0, wo:0, o:1, dev:sdc1
>> disk 1, wo:1, o:1, dev:sdd1
>> md: recovery of RAID array md2
>> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> md: using maximum available idle IO bandwidth (but not more than 
>> 200000 KB/sec) for recovery.
>> md: using 128k window, over a total of 117218176 blocks.
>> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> ata4.00: status: { DRDY }
>> ata4: hard resetting link
>> ata4: port is slow to respond, please be patient (Status 0x80)
>> ata4: softreset failed (device not ready)
>> ata4: hard resetting link
>> ata4: port is slow to respond, please be patient (Status 0x80)
>> ata4: softreset failed (device not ready)
>> ata4: hard resetting link
>> ata4: port is slow to respond, please be patient (Status 0x80)
>> ata4: softreset failed (device not ready)
>> ata4: limiting SATA link speed to 1.5 Gbps
>> ata4: hard resetting link
>> ata4: softreset failed (device not ready)
>> ata4: reset failed, giving up
>> ata4.00: disabled
>
> Are you sure this is not a hardware problem (bad disk, cable, etc?) Is
> it always ata4 that fails?
>
I'm sure - it's not hardware problem, I testing different disks,  and 
not always ata4 fails, sometimes  ata3, but ata5 - always.

