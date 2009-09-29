Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZI2OA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZI2OA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZI2OA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:00:27 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:52045 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZI2OA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:00:26 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2009 10:00:26 EDT
Date: Tue, 29 Sep 2009 15:52:59 +0200 (CEST)
From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
To: linux-kernel@vger.kernel.org
Subject: still mtrr problems
Message-ID: <Pine.A41.4.64.0909291547160.1114112@stalin.acc.umu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

when installing 8G RAM on an Intel DG965OT motherboard Linux will hang at 
boot (or parhaps only become very very slow) if I dont add the boot option 
mem=8192M, Windows Vista 64-bit works without any probelm on the same 
hardware.

/proc/mtrr:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcf800000 (3320MB), size=   8MB: uncachable, count=1
reg04: base=0xcf700000 (3319MB), size=   1MB: uncachable, count=1
reg05: base=0x100000000 (4096MB), size=4096MB: write-back, count=1
reg06: base=0x200000000 (8192MB), size= 512MB: write-back, count=1
reg07: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=1

dmesg|grep e820:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf561000 (usable)
[    0.000000]  BIOS-e820: 00000000cf561000 - 00000000cf56e000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf56e000 - 00000000cf637000 (usable)
[    0.000000]  BIOS-e820: 00000000cf637000 - 00000000cf6e9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf6e9000 - 00000000cf6ed000 (usable)
[    0.000000]  BIOS-e820: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6f3000 (usable)
[    0.000000]  BIOS-e820: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
[    0.000000]  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
