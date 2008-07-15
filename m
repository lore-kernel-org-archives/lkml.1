Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYGODsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYGODsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYGODr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:47:59 -0400
Received: from slackware.com ([64.57.102.34]:58611 "EHLO bob.slackware.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbYGODr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:47:58 -0400
Date: Mon, 14 Jul 2008 20:47:38 -0700 (PDT)
From: Piter PUNK <piterpunk@slackware.com>
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot
In-Reply-To: <487B403F.5040704@gmail.com>
Message-ID: <Pine.LNX.4.63.0807142036180.2473@bob.slackware.com>
References: <Pine.LNX.4.63.0806141945270.2761@bob.slackware.com>
 <487B403F.5040704@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This change made into the kernel in commit 9a3b103c...  Today, I
> tested a SIS968 board whose lspci -nn output looks like the following.
>
>  00:00.0 Host bridge [Class 0600]: Silicon Integrated Systems [SiS] 671MX [1039:0671]
>  00:01.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:0004]
>  00:02.0 ISA bridge [Class 0601]: Silicon Integrated Systems [SiS] SiS968 [MuTIOL Media IO] [1039:0968] (rev 01)
>  00:02.5 IDE interface [Class 0101]: Silicon Integrated Systems [SiS] 5513 [IDE] [1039:5513] (rev 01)
>  00:03.0 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f)
>  00:03.1 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 1.0 Controller [1039:7001] (rev 0f)
>  00:03.3 USB Controller [Class 0c03]: Silicon Integrated Systems [SiS] USB 2.0 Controller [1039:7002]
>  00:04.0 Ethernet controller [Class 0200]: Silicon Integrated Systems [SiS] 191 Gigabit Ethernet Adapter [1039:0191] (rev 02)
>  00:05.0 SATA controller [Class 0106]: Silicon Integrated Systems [SiS] AHCI IDE Controller (0106) [1039:1185] (rev 03)
>  00:06.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:000a]
>  00:07.0 PCI bridge [Class 0604]: Silicon Integrated Systems [SiS] PCI-to-PCI bridge [1039:000a]
>  00:0d.0 VGA compatible controller [Class 0300]: ATI Technologies Inc Radeon RV100 QZ [Radeon 7000/VE] [1002:515a]
>  00:0f.0 Audio device [Class 0403]: Silicon Integrated Systems [SiS] Azalia Audio Controller [1039:7502]
>  00:10.0 RAID bus controller [Class 0104]: HighPoint Technologies, Inc. HPT372A/372N [1103:0005] (rev 02)
>  02:00.0 Ethernet controller [Class 0200]: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) [8086:10b9] (rev 06)
>
> And the AHCI controller 1039:1185 @ 00:05.0 works just fine with
> regular devices and PMPs.  Can you please post lspci -nn output on
> your machine?  It seems the blacklisting was too wide.

OK.

That is the lspci-nn output:

00:00.0 Host bridge [0600]: Silicon Integrated Systems [SiS] 671MX [1039:0671]
00:01.0 PCI bridge [0604]: Silicon Integrated Systems [SiS] SiS AGP Port (virtual PCI-to-PCI bridge) [1039:0003]
00:02.0 ISA bridge [0601]: Silicon Integrated Systems [SiS] SiS968 [MuTIOL Media IO] [1039:0968] (rev 01)
00:02.5 IDE interface [0101]: Silicon Integrated Systems [SiS] 5513 [IDE] [1039:5513] (rev 01)
00:03.0 USB Controller [0c03]: Silicon Integrated Systems [SiS] USB 1.1 Controller [1039:7001] (rev 0f)
00:03.1 USB Controller [0c03]: Silicon Integrated Systems [SiS] USB 1.1 Controller [1039:7001] (rev 0f)
00:03.3 USB Controller [0c03]: Silicon Integrated Systems [SiS] USB 2.0 Controller [1039:7002]
00:04.0 Ethernet controller [0200]: Silicon Integrated Systems [SiS] 191 Gigabit Ethernet Adapter [1039:0191] (rev 02)
00:05.0 SATA controller [0106]: Silicon Integrated Systems [SiS] AHCI IDE Controller (0106) [1039:1185] (rev 03)
00:0f.0 Audio device [0403]: Silicon Integrated Systems [SiS] Azalia Audio Controller [1039:7502]
01:00.0 VGA compatible controller [0300]: Silicon Integrated Systems [SiS] 771/671 PCIE VGA Display Adapter [1039:6351] (rev 10)

The main differences that i can see are the internal SiS video chip and
the "SiS AGP Port".

Hope it can help

Piter Punk
