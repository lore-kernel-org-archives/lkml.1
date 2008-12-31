Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYLaT5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYLaT5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYLaT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:57:03 -0500
Received: from mail.lang.hm ([64.81.33.126]:49240 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbYLaT5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:57:01 -0500
Date: Wed, 31 Dec 2008 12:59:08 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Andi Kleen <andi@firstfloor.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <20081231195005.GT496@one.firstfloor.org>
Message-ID: <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm>
 <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Andi Kleen wrote:

>> on the picture you sent me i noticed the message
>> "Your memory is not aligned you need to rebuild your
>> kernel with bigger NODEMAP SIZE shift=20" and then
>> srat code complains about "No NUMA code hash function found"
>> which looks a bit scary. Btw, could you post this picture
>> on some public resource so NUMA people could check it?
>
> This case used to be handled cleanly (NUMA disabled), but perhaps
> that has regressed. But still it sounds like something is going wrong,
> unless his machine really has a very weird memory map.

it shouldn't, it was one of the high-volume servers 4-5 years ago and only 
has 4G of ram in it

here's the start of the boot with 2.6.25 (32 bit)

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000004cff0000 (usable)
  BIOS-e820: 000000004cff0000 - 000000004cfff000 (ACPI data)
  BIOS-e820: 000000004cfff000 - 000000004d000000 (ACPI NVS)
  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00ff780] 000ff780
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
   HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->  1048576
On node 0 totalpages: 1048576
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   HighMem zone: 6400 pages used for memmap
   HighMem zone: 812800 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.3 present.

