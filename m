Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYF0NBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYF0NBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYF0NBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:01:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:36967 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYF0NBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DUxDL+m9z5EmjycbqNFlkFOJJFk+xmS7RyBZTQZ4G61PhfweHnVRWjUU1WwfBiWN49
         BqDKqD4IezPYcJ7OhtbjrGyVVcIgoDrCPGEoHapbqVtMtezVxP2Lj8bqg5JYVYJc5Awo
         5Pg4SesymixfgM3YRV7Nhp/cYJvlsLFQUXj8g=
Message-ID: <386072610806270601o7601bbfes5e42f3228c988e65@mail.gmail.com>
Date: Fri, 27 Jun 2008 21:01:09 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Subject: Re: panic on blackfin, serial driver bug or hardware glitch?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200806261144.42290.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806261144.42290.denys@visp.net.lb>
X-Google-Sender-Auth: e6099b0a28836bcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 4:44 PM, Denys Fedoryshchenko <denys@visp.net.lb> wrote:
> After adding to initramfs just one more file (this file doesn't affect init process at all) got panic.
> I am not sure it is hardware failure(it is not standard board), but before i was not getting anything like this. Maybe bug in blackfin serial driver?
>
> Kernel is 2.6.27-rc7
>

Where is 2.6.27-rc7 tree?
In our daily build system, upstream mainline is ok for Blackfin. If
you want to use Blackfin Linux for you product, please goto
blackfin.uclinux.org

-Bryan

> [42949373.800000] partitions[1] = {.name = kernel, .offset = 0x00000000ffffffff, .size = 0x00000000200000 (2048KiB) }
> [42949373.810000] partitions[2] = {.name = file system, .offset = 0x00000000ffffffff, .size = 0x00000000 (0KiB) }
> [42949373.820000] Creating 3 MTD partitions on "m25p80":
> [42949373.820000] 0x00000000-0x0000000040000 : "bootloader"
> [42949373.830000] mtd: partition "bootloader" doesn't end on an erase block -- force read-only
> [42949373.840000] mtd: Giving out device 0 to bootloader
> [42949373.840000] spi0.2: m25p80_read from 0x00000000, len 68
> [42949373.850000] ftl_cs: FTL header corrupt!
> [42949373.850000] 0x0000000040000-0x00000000240000 : "kernel"
> [42949373.860000] mtd: partition "kernel" doesn't start on an erase block boundary -- force read-only
> [42949373.870000] mtd: Giving out device 1 to kernel
> [42949373.870000] spi0.2: m25p80_read from 0x0000000040000, len 68
> [42949373.880000] spi0.2: m25p80_read from 0x00000000c0000, len 68
> [42949373.880000] ftl_cs: FTL header not found.
> [42949373.890000] 0x00000000240000-0x000000004000000 : "file system"
> [42949373.900000] mtd: partition "file system" doesn't start on an erase block boundary -- force read-only
> [42949373.910000] mtd: Giving out device 2 to file system
> [42949373.910000] spi0.2: m25p80_read from 0x00000000240000, len 68
> [42949373.920000] spi0.2: m25p80_read from 0x000000002c0000, len 68
> [42949373.930000] ftl_cs: FTL header not found.
> [42949373.930000] bfin-spi bfin-spi.0: Blackfin BF5xx on-chip SPI Controller Driver, Version 1.0, regs_base@00000000ffc00500, dma channel@5
> [42949373.940000] rtc-bfin rtc-bfin: rtc core: registered rtc-bfin as rtc0
> [42949373.950000] rtc-bfin rtc-bfin: setting system clock to 2031-07-28 00:48:45 UTC (1942966125)
> [42949373.960000] Freeing unused kernel memory: 864k freed
> [42949373.970000] dma_alloc_init: dma_page @ 0x00000000122000 - 256 pages at 0x000000001f00000
> #[42949375.450000] NULL pointer access
> [42949375.450000] Deferred Exception context
> [42949375.450000] CURRENT PROCESS:
> [42949375.450000] COMM=linuxrc PID=26
> [42949375.450000] TEXT = 0x00000000180000-0x000000001b8b3c        DATA = 0x000000001df4b3c-0x000000001df7ce8
> [42949375.450000]  BSS = 0x000000001df7ce8-0x000000001c20000  USER-STACK = 0x000000001c3fef0
> [42949375.450000]
> [42949375.450000] return address: [0x000000001f3da2]; contents of:
> [42949375.450000] 0x000000001f3d80:  00000000c07  00000000185a  00000000321c  00000000a2f9  00000000b0f1  00000000ce82  000000008027  00000000a23a
> [42949375.450000] 0x000000001f3d90:  0000  000000005005  00000000300e  00000000e3ff  00000000eb17  00000000c00  000000003010  000000001fed
> [42949375.450000] 0x000000001f3da0:  000000003212 [00000000e490] 00000000c  000000004e20  0000000067f8  00000000e08  00000000143d  00000000af3b
> [42949375.450000] 0x000000001f3db0:  00000000c43  000000001802  00000000935c  00000000a2f8  00000000c80  000000001887  0000  00000000320a
> [42949375.450000]
> [42949375.450000] SEQUENCER STATUS:Not tainted
> [42949375.450000]  SEQSTAT: 0000000062027  IPEND: 0000000030  SYSCFG: 000000006
> [42949375.450000]   HWERRCAUSE: 0x0000000018
> [42949375.450000]   EXCAUSE   : 0x0000000027
> [42949375.450000]  RETE: <0x00000000> /* Maybe null pointer? */
> [42949375.450000]  RETN: <0x000000001e8000> { ___con_initcall_end + 0x00000000b7b14 }
> [42949375.450000]  RETX: <0x00000000480> /* Maybe fixed code section */
> [42949375.450000]  RETS: <0x000000001f3d9a> { ___con_initcall_end + 0x00000000c38ae }
> [42949375.450000]  PC  : <0x000000001f3da2> { ___con_initcall_end + 0x00000000c38b6 }
> [42949375.450000] DCPLB_FAULT_ADDR: <0x00000000c> /* Maybe null pointer? */
> [42949375.450000] ICPLB_FAULT_ADDR: <0x000000001f3da2> { ___con_initcall_end + 0x00000000c38b6 }
> [42949375.450000]
> [42949375.450000] PROCESSOR STATE:
> [42949375.450000]  R0 : 00000000    R1 : 000000006d    R2 : 00000000    R3 : 00000000184d21
> [42949375.450000]  R4 : 00000000130f78    R5 : 0000000018148c    R6 : 0000000018416c    R7 : 000000006d
> [42949375.450000]  P0 : 00000000184d22    P1 : 000000001846fc    P2 : 00000000    P3 : 00000000130f78
> [42949375.450000]  P4 : 00000000136028    P5 : 00000000180130    FP : 000000001c3f9cc    SP : 000000001e7f24
> [42949375.450000]  LB0: 000000001f6181    LT0: 000000001f6174    LC0: 00000000
> [42949375.450000]  LB1: 000000001f4ec7    LT1: 000000001f4ec6    LC1: 00000000
> [42949375.450000]  B0 : 00000000    L0 : 00000000    M0 : 00000000    I0 : 00000000b928
> [42949375.450000]  B1 : 00000000    L1 : 00000000    M1 : 00000000    I1 : 00000000136154
> [42949375.450000]  B2 : 00000000    L2 : 00000000    M2 : 00000000    I2 : 00000000
> [42949375.450000]  B3 : 00000000    L3 : 00000000    M3 : 00000000    I3 : 00000000
> [42949375.450000] A0.w: 00000000   A0.x: 00000000   A1.w: 00000000   A1.x: 00000000
> [42949375.450000] USP : 000000001c3f994  ASTAT: 000000002003005
> [42949375.450000]
> [42949375.450000] Hardware Trace:
> [42949375.450000]    0 Target : <0x000000003f10> { _trap_c + 0x0 }
> [42949375.450000]      Source : <0x00000000ffa00450> /* unknown address */
> [42949375.450000]    1 Target : <0x00000000ffa003b4> /* unknown address */
> [42949375.450000]      Source : <0x00000000ffa0030a> /* unknown address */
> [42949375.450000]    2 Target : <0x00000000ffa00298> /* unknown address */
> [42949375.450000]      Source : <0x00000000ffa004d8> /* unknown address */
> [42949375.450000]    3 Target : <0x00000000ffa004b0> /* unknown address */
> [42949375.450000]      Source : <0x000000001f3da0> { ___con_initcall_end + 0x00000000c38b4 }
> [42949375.450000]    4 Target : <0x000000001f3d9a> { ___con_initcall_end + 0x00000000c38ae }
> [42949375.450000]      Source : <0x000000001f13e2> { ___con_initcall_end + 0x00000000c0ef6 }
> [42949375.450000]    5 Target : <0x000000001f13da> { ___con_initcall_end + 0x00000000c0eee }
> [42949375.450000]      Source : <0x000000001f141e> { ___con_initcall_end + 0x00000000c0f32 }
> [42949375.450000]    6 Target : <0x000000001f1406> { ___con_initcall_end + 0x00000000c0f1a }
> [42949375.450000]      Source : <0x000000001f1416> { ___con_initcall_end + 0x00000000c0f2a }
> [42949375.450000]    7 Target : <0x000000001f13e4> { ___con_initcall_end + 0x00000000c0ef8 }
> [42949375.450000]      Source : <0x000000001f13d8> { ___con_initcall_end + 0x00000000c0eec }
> [42949375.450000]    8 Target : <0x000000001f13c4> { ___con_initcall_end + 0x00000000c0ed8 }
> [42949375.450000]      Source : <0x000000001f3d96> { ___con_initcall_end + 0x00000000c38aa }
> [42949375.450000]    9 Target : <0x000000001f3d78> { ___con_initcall_end + 0x00000000c388c }
> [42949375.450000]      Source : <0x000000001f3d9e> { ___con_initcall_end + 0x00000000c38b2 }
> [42949375.450000]   10 Target : <0x000000001f3d9a> { ___con_initcall_end + 0x00000000c38ae }
> [42949375.450000]      Source : <0x000000001f13e2> { ___con_initcall_end + 0x00000000c0ef6 }
> [42949375.450000]   11 Target : <0x000000001f13da> { ___con_initcall_end + 0x00000000c0eee }
> [42949375.450000]      Source : <0x000000001f141e> { ___con_initcall_end + 0x00000000c0f32 }
> [42949375.450000]   12 Target : <0x000000001f1406> { ___con_initcall_end + 0x00000000c0f1a }
> [42949375.450000]      Source : <0x000000001f1416> { ___con_initcall_end + 0x00000000c0f2a }
> [42949375.450000]   13 Target : <0x000000001f13e4> { ___con_initcall_end + 0x00000000c0ef8 }
> [42949375.450000]      Source : <0x000000001f13d8> { ___con_initcall_end + 0x00000000c0eec }
> [42949375.450000]   14 Target : <0x000000001f13c4> { ___con_initcall_end + 0x00000000c0ed8 }
> [42949375.450000]      Source : <0x000000001f3d96> { ___con_initcall_end + 0x00000000c38aa }
> [42949375.450000]   15 Target : <0x000000001f3d78> { ___con_initcall_end + 0x00000000c388c }
> [42949375.450000]      Source : <0x000000001f3d9e> { ___con_initcall_end + 0x00000000c38b2 }
> [42949375.450000] Stack from 000000001e7efc:
> [42949375.450000]         00000000 00000000ffa00610 000000001c3f9cc 00000000ffa00454 00000000ffa009b4 000000006d 00000000ffff 000000002
> [42949375.450000]         00000000130f78 000000001f518c 00000000480 0000000030 0000000062027 00000000 000000001e8000 00000000480
> [42949375.450000]         000000001f3da2 000000001f3d9a 00000000 000000002003005 000000001f4ec7 000000001f6181 000000001f4ec6 000000001f6174
> [42949375.450000]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [42949375.450000]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [42949375.450000]         00000000 00000000 00000000 00000000 00000000136154 00000000b928 000000001c3f994 000000001c3f9cc
> [42949375.450000]
> [42949375.450000] Call Trace:
> [42949375.450000]
> [42949375.450000]
> [42949375.450000] Double Fault
> [42949375.450000] Kernel OOPS in progress
> [42949375.450000] Deferred Exception context
> [42949375.450000] CURRENT PROCESS:
> [42949375.450000] COMM=linuxrc PID=26
> [42949375.450000] TEXT = 0x00000000180000-0x000000001b8b3c        DATA = 0x000000001df4b3c-0x000000001df7ce8
> [42949375.450000]  BSS = 0x000000001df7ce8-0x000000001c20000  USER-STACK = 0x000000001c3fef0
> [42949375.450000]
> [42949375.450000] return address: [0x000000001c3fab4]; contents of:
> [42949375.450000] 0x000000001c3fa90:  00000000416c  0000000018  00000000148c  0000000018  00000000a9  0000  00000000fad0  000000001c3
> [42949375.450000] 0x000000001c3faa0:  000000001bac  000000001f  000000006028  0000000013  000000006120  0000000013  0000  0000
> [42949375.450000] 0x000000001c3fab0:  0000  0000 [000000001250] 0000000013  00000000f78  0000000013  000000006028  0000000013
> [42949375.450000] 0x000000001c3fac0:  000000006120  0000000013  000000001bee  000000001f  00000000548  0000  00000000f60  0000000013
> [42949375.450000]
> [42949375.450000] SEQUENCER STATUS:Not tainted
> [42949375.450000]  SEQSTAT: 0000000062021  IPEND: 00000000480  SYSCFG: 000000006
> [42949375.450000]   HWERRCAUSE: 0x0000000018
> [42949375.450000]   EXCAUSE   : 0x0000000021
> [42949375.450000]   physical IVG7 asserted : <0x00000000ffa00ac0> /* unknown address */
> [42949375.450000]   physical IVG10 asserted : <0x00000000ffa00ae4> /* unknown address */
> [42949375.450000]   logical irq   6 mapped  : <0x00000000aaab4> { _timer_interrupt + 0x0 }
> [42949375.450000]   logical irq  21 mapped  : <0x0000000088fa0> { _bfin_serial_dma_rx_int + 0x0 }
> [42949375.450000]   logical irq  22 mapped  : <0x0000000088f10> { _bfin_serial_dma_tx_int + 0x0 }
> [42949375.450000]  RETE: <0x00000000> /* Maybe null pointer? */
> [42949375.450000]  RETN: <0x000000001e7f14> { ___con_initcall_end + 0x00000000b7a28 }
> [42949375.450000]  RETX: <0x000000001c3fab4> [ linuxrc + 0x000000001fab4 ]
> [42949375.450000]  RETS: <0x000000001c3f9cc> [ linuxrc + 0x000000001f9cc ]
> [42949375.450000]  PC  : <0x000000001c3fab4> [ linuxrc + 0x000000001fab4 ]
> [42949375.450000] DCPLB_FAULT_ADDR: <0x00000000c> /* Maybe null pointer? */
> [42949375.450000] ICPLB_FAULT_ADDR: <0x000000001f3da2> { ___con_initcall_end + 0x00000000c38b6 }
> [42949375.450000]
> [42949375.450000] PROCESSOR STATE:
> [42949375.450000]  R0 : 00000000    R1 : 00000000ffffffcd    R2 : 00000000    R3 : 00000000
> [42949375.450000]  R4 : 00000000130f78    R5 : 00000000100d    R6 : 000000006d    R7 : 00000000ffa009b4
> [42949375.450000]  P0 : 000000001de329c    P1 : 000000001cb28a0    P2 : 00000000ffe06000    P3 : 00000000130f78
> [42949375.450000]  P4 : 00000000ffe02014    P5 : 00000000ffa00454    FP : 00000000ffa00615    SP : 000000001e7e38
> [42949375.450000]  LB0: 00000000ffa0106a    LT0: 00000000ffa0106a    LC0: 00000000
> [42949375.450000]  LB1: 000000001f4ec7    LT1: 000000001f4ec6    LC1: 00000000
> [42949375.450000]  B0 : 00000000    L0 : 00000000    M0 : 00000000    I0 : 000000001e7d8c
> [42949375.450000]  B1 : 00000000    L1 : 00000000    M1 : 00000000    I1 : 000000001e7e9c
> [42949375.450000]  B2 : 00000000    L2 : 00000000    M2 : 00000000    I2 : 00000000ffff8bc9
> [42949375.450000]  B3 : 00000000    L3 : 00000000    M3 : 00000000    I3 : 00000000
> [42949375.450000] A0.w: 00000000   A0.x: 00000000   A1.w: 00000000   A1.x: 00000000
> [42949375.450000] USP : 000000001c3f994  ASTAT: 000000002003004
> [42949375.450000]
> [42949375.450000] Kernel panic - not syncing: Double Fault - unrecoverable event
> [42949375.450000]
> [42949375.450000] Rebooting in 10 seconds..
>
>
> --
> ------
> Technical Manager
> Virtual ISP S.A.L.
> Lebanon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
