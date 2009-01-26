Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZAZOja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZAZOja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZAZOjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:39:22 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:44216 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZAZOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:39:21 -0500
Message-ID: <497DCB15.7030404@turknet.net.tr>
Date: Mon, 26 Jan 2009 16:39:17 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090125 Shredder/3.0b2pre
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Nick Andrew <nick@nick-andrew.net>,
       Trivial Kernel Patches <trivial@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH 00/20] Fix misspelling of "firmware"
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net> <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901261059560.5377@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2009 14:39:18.0057 (UTC) FILETIME=[DE3BA190:01C97FC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2009 12:00 PM, Jiri Kosina wrote:
> On Mon, 26 Jan 2009, Nick Andrew wrote:
>
>    
>> Fix more misspellings of "firmware" which I noticed in v2.6.29-rc2. All are
>> comment changes.
>> Nick.
>> ---
>>
>> Nick Andrew (20):
>>        Fix misspelling of firmware in iwl-agn.c
>>        Fix misspelling of firmware in iwl3945-base.c
>>        Fix misspelling of firmware in hpmain.c
>>        Fix misspelling of firmware in head_64.S
>>        Fix misspelling of firmware in aica.c
>>        Fix misspelling of firmware in pss.c
>>        Fix misspelling of firmware in disk.c
>>        Fix misspelling of firmware in libata.h
>>        Fix misspelling of firmware in ChangeLog.history
>>        Fix misspelling of firmware in ueagle-atm.c
>>        Fix misspelling of firmware in pci.c
>>        Fix misspelling of firmware in cmd.c
>>        Fix misspelling of firmware in ipw2200.c
>>        Fix misspelling of firmware in ipw2100.c
>>        Fix misspelling of firmware in tg3.c
>>        Fix misspelling of firmware in sb1250-mac.c
>>        Fix misspelling of firmware in thinkpad_acpi.c
>>        Fix misspelling of "firmware" in ip27-smp.c
>>        Fix misspelling of "firmware" in firmware.txt
>>        Fix misspelling of "firmware" in ia64-kvm.txt
>>      
>
> I will fold all this into single patch and apply.
>
> Thanks,
>
>    
"Fix misspelling of firmware in tg3.c" didn't help me to solve tg3 
firmware issue which I submitted via "[BUG] tg3 module problem on 
Linux-2.6.29-rc1-2" subjected email at 21st of Jan. I re-compiled 
2.6.29-rc2 with this patch and still having the same error message :

Using mkinitramfs-kpkg to build the ramdisk.
W: Possible missing firmware 
/lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso5.bin for module tg3
W: Possible missing firmware 
/lib/firmware/2.6.29-rc2-git1/tigon/tg3_tso.bin for module tg3
W: Possible missing firmware /lib/firmware/2.6.29-rc2-git1/tigon/tg3.bin 
for module tg3


Tarkan ERIMER
