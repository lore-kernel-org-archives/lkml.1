Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbXLDRl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbXLDRl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 12:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXLDRlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 12:41:21 -0500
Received: from ns1.primeinteractive.net ([195.95.205.253]:56047 "EHLO
	mail.primeinteractive.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbXLDRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 12:41:20 -0500
X-Quarantine-ID: <Jdp96Kl4ujbt>
Message-ID: <47559131.4070800@primeinteractive.net>
Date: Tue, 04 Dec 2007 18:41:05 +0100
From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Zid Null <zidsoft@gmail.com>
CC: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ICH9 & Core2 Duo - kernel crash
References: <200712041331.24678.pavol.cvengros@primeinteractive.net>	 <6101e8c40712040710w22fe220ewb85eccfeb1a55740@mail.gmail.com>	 <200712041631.53485.pavol.cvengros@primeinteractive.net> <328e43f00712040901i6ef853eanee3e43fceacc447e@mail.gmail.com>
In-Reply-To: <328e43f00712040901i6ef853eanee3e43fceacc447e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have one P35 machine too. And it's running ok (my workstation). The 
problem is with this board and chipset Intel G33 Express.

I am going to test vanilla 2.6.22 kernels and latest devel kernel too 
next few days.

Zid Null wrote:
> I'm using ICH9 on this machine currently, works fine. (p35 chipset though)
>
> On 04/12/2007, *Pavol Cvengros* < pavol.cvengros@primeinteractive.net 
> <mailto:pavol.cvengros@primeinteractive.net>> wrote:
>
>     On Tuesday 04 December 2007 16:10:40 Olivér Pintér wrote:
>     > On 12/4/07, Pavol Cvengros <pavol.cvengros@primeinteractive.net
>     <mailto:pavol.cvengros@primeinteractive.net>> wrote:
>     > > Hello,
>     > >
>     > > I am trying LKML to get some help on one linux kernel related
>     problem.
>     > > Lately we got a machine with new HW from Intel. CPU is Intel
>     Core2 Duo
>     > > E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with
>     G33 chipset.
>     > >
>     > > After long fight with kernel crashes on different things, we
>     figured out
>     > > that
>     > > if the multicore is disabled in bios, everything is ok and
>     machine is
>     > > running
>     > > good. No kernel crashes no problems, but with one core only.
>     > >
>     > > This small table will maybe explain:
>     > >
>     > > Cores   -     kernel   -   state
>     > >    2  -   nonsmp or smp  - crash
>     > >    1  -  smp or nonsmp  - ok
>     > >
>     > > All crashes have been different (swaper, rcu, irq, init.....)
>     or we just
>     > > got internal gcc compiler error while compiling
>     kernel/glibc/.... and the
>     > > machine
>     > > was frozen.
>     > >
>     > > Please can somebody advise what to do to identify that problem
>     more
>     > > precisely.
>     > > (debug kernel options?)
>     > >
>     > > Our immpresion - ICH9 & ICH9R support in kernel is bad...
>     sorry to say..
>     > >
>     > > lspci:
>     > > 00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
>     > > 00:02.0 VGA compatible controller: Intel Corporation
>     Integrated Graphics
>     > > Controller (rev 02)
>     > > 00:03.0 Communication controller: Intel Corporation MEI
>     Controller (rev
>     > > 02) 00: 1a.0 USB Controller: Intel Corporation USB UHCI
>     Controller #4 (rev
>     > > 02) 00:1a.1 USB Controller: Intel Corporation USB UHCI
>     Controller #5 (rev
>     > > 02) 00:1a.2 USB Controller: Intel Corporation USB UHCI
>     Controller #6 (rev
>     > > 02) 00:1a.7 USB Controller: Intel Corporation USB2 EHCI
>     Controller #2
>     > > (rev 02) 00:1c.0 PCI bridge: Intel Corporation PCI Express
>     Port 1 (rev
>     > > 02) 00:1c.1 PCI bridge: Intel Corporation PCI Express Port 2
>     (rev 02)
>     > > 00:1c.2 PCI bridge: Intel Corporation PCI Express Port 3 (rev
>     02) 00:1c.3
>     > > PCI bridge: Intel Corporation PCI Express Port 4 (rev 02)
>     00:1c.4 PCI
>     > > bridge: Intel Corporation PCI Express Port 5 (rev 02) 00: 1d.0 USB
>     > > Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
>     00:1d.1 USB
>     > > Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
>     00:1d.2 USB
>     > > Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
>     00: 1d.7 USB
>     > > Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
>     00:1e.0
>     > > PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
>     > > 00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller
>     (rev 02)
>     > > 00:1f.2 IDE interface: Intel Corporation 4 port SATA IDE
>     Controller (rev
>     > > 02) 00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
>     > > 00:1f.5 IDE interface: Intel Corporation 2 port SATA IDE
>     Controller (rev
>     > > 02) 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
>     > > single-port PATA133 interface (rev b1)
>     > > 06:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>     > > RTL-8139/8139C/8139C+ (rev 10)
>     > >
>     > > Thanks for any kind of help...
>     >
>     > kernel version?
>
>     tested with:
>     vanila 2.6.23.9 <http://2.6.23.9>
>     gentoo-2.6.23-r2
>
>
>     --
>     -----------[ Signature ]---------
>     Name: Pavol Cvengros
>     Company: Prime Interactive, Ltd.
>     E-mail: pavol.cvengros@primeinteractive.net
>     <mailto:pavol.cvengros@primeinteractive.net>
>     Web: http://www.primeinteractive.net <http://www.primeinteractive.net>
>     Personal web: http://orpheus.grass.sk
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at  http://www.tux.org/lkml/
>     <http://www.tux.org/lkml/>
>
>

