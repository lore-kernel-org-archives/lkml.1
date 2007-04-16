Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXDPNNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXDPNNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXDPNNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:13:21 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:58133 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030519AbXDPNNU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:13:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 4GB Physical. Less than 3GB in Linux.
Date: Mon, 16 Apr 2007 09:12:56 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE6F2@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 4GB Physical. Less than 3GB in Linux.
Thread-Index: Acd/+NuKTRFrmLsFR5OqGQ78QoNp2wAL7yHg
References: <b6a2187b0704160028x3f979dc3s1c9e18995f229782@mail.gmail.com>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2007 13:12:57.0039 (UTC) FILETIME=[F32FC5F0:01C78028]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I've noticed that with 4GB physical ram, I'm only see 3098000 
> MB on the Dell 745, and 3107056MB on the IBM X60s.
> 
> I've tested with CONFIG_HIGHMEM4G=y, CONFIG_HIGHMEM64G=y, 
> CONFIG_X86_PAE=y, but nothing makes any difference.
> 
> Tested on Linux 2.6.20, Linux 2.6.21-rc7.

Got similar problem on a HP XW6200:
http://bugzilla.kernel.org/show_bug.cgi?id=7111

Tought I was the only one getting this!

> # dmesg
> copy_e820_map() start: 0000000000000000 size: 000000000009f000 end:
> 000000000009f000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 000000000009f000 size: 0000000000001000 end:
> 00000000000a0000 type: 2
> copy_e820_map() start: 00000000000dc000 size: 0000000000024000 end:
> 0000000000100000 type: 2
> copy_e820_map() start: 0000000000100000 size: 00000000bf5d0000 end:
> 00000000bf6d0000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 00000000bf6d0000 size: 000000000000f000 end:
> 00000000bf6df000 type: 3
> copy_e820_map() start: 00000000bf6df000 size: 0000000000021000 end:
> 00000000bf700000 type: 4
> copy_e820_map() start: 00000000bf700000 size: 0000000000900000 end:
> 00000000c0000000 type: 2
> copy_e820_map() start: 00000000f0000000 size: 0000000004000000 end:
> 00000000f4000000 type: 2
> copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end:
> 00000000fec10000 type: 2
> copy_e820_map() start: 00000000fed00000 size: 0000000000000400 end:
> 00000000fed00400 type: 2
> copy_e820_map() start: 00000000fed14000 size: 0000000000006000 end:
> 00000000fed1a000 type: 2
> copy_e820_map() start: 00000000fed1c000 size: 0000000000074000 end:
> 00000000fed90000 type: 2
> copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end:
> 00000000fee01000 type: 2
> copy_e820_map() start: 00000000ff800000 size: 0000000000800000 end:
> 0000000100000000 type: 2
>  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
>  BIOS-e820: 00000000bf6d0000 - 00000000bf6df000 (ACPI data)
>  BIOS-e820: 00000000bf6df000 - 00000000bf700000 (ACPI NVS)
>  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved) 
> 2166MB HIGHMEM available.
> 896MB LOWMEM available.
> 
> Memory: 3106140k/3136320k available (2225k kernel code, 
> 29072k reserved, 910k data, 196k init, 2218816k highmem) 
> virtual kernel memory layout:
>     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc0416000 - 0xc0447000   ( 196 kB)
>       .data : 0xc032c513 - 0xc040ff34   ( 910 kB)
>       .text : 0xc0100000 - 0xc032c513   (2225 kB)
> 
> 
> Thanks,
> Jeff.

- vin
