Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbXGYLeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbXGYLeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 07:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbXGYLdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 07:33:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:49401 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759674AbXGYLdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 07:33:52 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/kgUUpFb7kVda3UUDGKCwsQ/g2Bcjqg0GdNdljtY
	QYjYAd8KRPimGN
Date: Wed, 25 Jul 2007 13:33:49 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Message-ID: <20070725113349.GB5469@alice>
References: <20070723221630.GA28951@alice> <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22.1 (x86_64)
X-Uptime: 13:32:39 up  2:45,  6 users,  load average: 0.65, 0.26, 0.22
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Michal Piotrowski (michal.k.k.piotrowski@gmail.com) wrote:
>  On 24/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> > see second 13 to 510, after pressing it about ten
> > times, it continues booting.
> 
>  Probing IDE interface...
> 
>  [   13.867939] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on
>  pci0000:00:04.1
>  [   13.868062]     ide0: BM-DMA at 0xd800-0xd807, BIOS settings:
>  hda:DMA, hdb:pio
>  [   13.868268]     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings:
>  hdc:DMA, hdd:DMA
>  [   13.868574] Probing IDE interface ide0...
>  [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
>  [  496.200082] hda: ST340823A, ATA DISK drive
>  [  510.264511] hda: selected mode 0x44
>  [  510.264826] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> 
>  Could you please try to revert these commits
> 
>  commit 4099d14322149c7a467e4997b87be4ba8eb78697
>  commit 6a824c92db4d606c324272c4eed366fb71672440
>  commit a5d8c5c834d3cabf4b7b477c3f6ee923c25026fc

reverting these commits didnt change anything at all,
booting with acpi=off resolved the issue, so i guess it is
an acpi problem after all.

Greetings, Eric
