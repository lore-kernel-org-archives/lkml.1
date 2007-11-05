Return-Path: <linux-kernel-owner+w=401wt.eu-S1756964AbXKESqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbXKESqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXKESq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:46:29 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:49864 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbXKESq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:46:28 -0500
Date: Mon, 5 Nov 2007 19:46:18 +0100 (CET)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 ten times slower than i386
In-Reply-To: <472F5195.2050403@zytor.com>
Message-ID: <Pine.A41.4.64.0711051945280.708776@stalin.acc.umu.se>
References: <Pine.A41.4.64.0711031329490.397338@stalin.acc.umu.se>
 <20071103162640.GS17536@waste.org> <Pine.A41.4.64.0711032334170.770224@stalin.acc.umu.se>
 <Pine.A41.4.64.0711051110530.803034@stalin.acc.umu.se>
 <Pine.A41.4.64.0711051657440.291004@stalin.acc.umu.se> <472F5195.2050403@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, H. Peter Anvin wrote:

>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
>> reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
>> reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
>> reg05: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
>> reg06: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
>
> What does your e820 map look like?

BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000cf561000 (usable)
  BIOS-e820: 00000000cf561000 - 00000000cf56e000 (reserved)
  BIOS-e820: 00000000cf56e000 - 00000000cf637000 (usable)
  BIOS-e820: 00000000cf637000 - 00000000cf6e9000 (ACPI NVS)
  BIOS-e820: 00000000cf6e9000 - 00000000cf6ed000 (usable)
  BIOS-e820: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
  BIOS-e820: 00000000cf6f2000 - 00000000cf6f3000 (usable)
  BIOS-e820: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 000000012c000000 (usable)

