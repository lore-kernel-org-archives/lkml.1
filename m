Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZBXS0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZBXS0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZBXS0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:26:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:52908 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbZBXS0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:26:40 -0500
Message-ID: <49A43B89.8050800@kernel.org>
Date: Tue, 24 Feb 2009 10:25:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
 	ioremap virtual address for G33 hw status page
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>	 <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>	 <8db1092f0902232254q10826fei8b8125b3da5f233@mail.gmail.com> <8db1092f0902240054jc2fd751m2c707bd687ddeab8@mail.gmail.com>
In-Reply-To: <8db1092f0902240054jc2fd751m2c707bd687ddeab8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/2/24 Maciej Rutecki <maciej.rutecki@gmail.com>:
>> 2009/2/24 Yinghai Lu <yinghai@kernel.org>:
>>
>>> CONFIG_MTRR=y
>>> CONFIG_MTRR_SANITIZER=y
>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>>
>>> should help mtrr ones.
>>>
>>> please post bootlog with those option set.
>>>
>>> YH
>>>
>> It doesn't help, see previous mails.
>>
>>
> 
> l also update bios, and try:
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> 
> it doesn't help:
> [    0.000000] Linux version 2.6.29-rc6 (root@zlom) (gcc version 4.3.3
> (Debian 4.3.3-3) ) #1 SMP PREEMPT Tue Feb 24 08:03:56 CET 2009
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf5e0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf5e0000 - 00000000bf5e3000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf5e3000 - 00000000bf5f0000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf5f0000 - 00000000bf600000 (reserved)
> [    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0xbf5e0 max_arch_pfn = 0x100000
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 4GB, type WB
> [    0.000000] reg 1, base: 3GB, range: 1GB, type UC
> [    0.000000] reg 2, base: 3064MB, range: 8MB, type UC
> [    0.000000] reg 3, base: 3063MB, range: 1MB, type UC
> [    0.000000] reg 4, base: 3062MB, range: 1MB, type UC
> [    0.000000] total RAM coverred: 3062M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
> [    0.000000] reg 2, base: 3062MB, range: 2MB, type UC
> [    0.000000] reg 3, base: 3064MB, range: 8MB, type UC

so kernel convert MTRR layout from continuous to discrete ...

YH
