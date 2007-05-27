Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbXE0KW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbXE0KW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXE0KWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:22:21 -0400
Received: from v6.netlin.pl ([62.121.136.6]:44831 "EHLO pointblue.com.pl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbXE0KWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:22:20 -0400
From: Tommy Vercetti <vercetti@zlew.org>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Date: Sun, 27 May 2007 12:22:29 +0200
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200705261505.38109@gj-laptop> <200705261746.01568@gj-laptop> <2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>
In-Reply-To: <2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271222.30169@gj-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 18:07, Ray Lee wrote:
> On 5/26/07, Tommy Vercetti <vercetti@zlew.org> wrote:
> > in terms of driver, what do you mean ?
>
> The software driver that handles the specific chipset for that drive.
> The thing that shows up when you do an lsmod, assuming you have the
> driver compiled as a module.

root@puppet:~# dmesg |grep -i ide
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
    ide0: BM-DMA at 0x1840-0x1847, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1848-0x184f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide1 at 0x170-0x177,0x376 on irq 15

it's compiled in. 
you reckon I should use something else for this platform ? 

> > /dev/hda:
> >  Timing cached reads:   732 MB in  2.00 seconds = 365.74 MB/sec
> >  Timing buffered disk reads:   76 MB in  3.00 seconds =  25.31 MB/sec
>
> That looks fine. Your filesystem may just be very fragmented. I'm not
> familiar with how reiser3 filesystems age, so if you've had the system
> installed for quite some time, it may be time to back it up and
> reinstall. Dunno.
yeah, and they say unix FSes don't need defragmentation.... my bottom...

-- 
Vercetti
