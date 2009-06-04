Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZFDOvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZFDOvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZFDOux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:50:53 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53667 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZFDOuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=upBS7Q+8z4cQQ5beuSuFeXcOu9sqgpFXGUXdrhAfuC3QuBFWbQwW95tB7DhB6hzwKm
         t78DDckBFSVHFuVw06zAubMlTHxxUCaLCAnvuoWZIYvdyBV+fZB9WmLDE/fMaIDOSTMG
         TwjHZIvrVG5wUoK6/xVxZmyHh5riSjzPJiGMs=
MIME-Version: 1.0
In-Reply-To: <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	 <4A25F688.9000407@gmail.com>
	 <c5bd819b0906030435w466368cbsd48be91a97597437@mail.gmail.com>
	 <20090603131407.57c490ed@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030552w6f23185etb394f83c8b630e6@mail.gmail.com>
	 <20090603140140.491a8ea8@lxorguk.ukuu.org.uk>
	 <c5bd819b0906030639o5f9c34ffg500e132d3a0b5117@mail.gmail.com>
Date: Thu, 4 Jun 2009 16:50:52 +0200
Message-ID: <c5bd819b0906040750w75e0389cod2a03b89ce838d1b@mail.gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
From: Grozdan <neutrino8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/3 Grozdan <neutrino8@gmail.com>:
> 2009/6/3 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> What about 2.6.28 or 2.6.29 ?
>>
>
> Hi,
>
> I just installed kernel 2.6.29.4-rt16-2-rt from the SUSE build service
> (there's no 2.6.28 one available nor a 'normal' 2.6.29 one) and my
> UDMA is set correctly just as when using the default 2.6.27.21 kernel.
> Now I'm not sure if there really is a problem in 2.6.30-rc7-git4 or
> did I somehow introduced it by configuring something incorrectly
> (which I doubt because as I said, I didn't touch anything related to
> IDE during configuration. I only tweaked a few options, most of them
> in the General and Processor sections).
>
> ---------- dmesg IDE of 2.6.29.4-rt16-2-rt----------------
>
> pata_via 0000:00:0f.0: PCI INT A -> Link[ALKA] -> GSI 20 (level, low) -> IRQ 20
> scsi0 : pata_via
> scsi1 : pata_via
> ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xdc00 irq 14
> ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xdc08 irq 15
> ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> ata1.00: 160086528 sectors, multi 16: LBA
> ata1.01: ATA-5: ST340016A, 3.10, max UDMA/100
> ata1.01: 78165360 sectors, multi 16: LBA
> ata1.00: configured for UDMA/133
> ata1.01: configured for UDMA/100
> isa bounce pool size: 16 pages
> scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
> scsi 0:0:1:0: Direct-Access     ATA      ST340016A        3.10 PQ: 0 ANSI: 5
> ata2.00: ATAPI: TSSTcorpCD/DVDW TS-H552U, US08, max UDMA/33
> ata2.00: configured for UDMA/33
> scsi 1:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-H552U US08 PQ: 0 ANSI: 5
> BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
> udevd version 128 started
> Driver 'sd' needs updating - please use bus_type methods
> sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
>

Adding more information. A user on the openSUSE forum which is trying
out openSUSE 11.2 milestone 2 (with kernel 2.6.30-rc6-git3) is having
the same problems. His computer is using the pata_amd driver instead
of pata_via like mine and he too gets limiting to UDMA33 during boot

Link: http://forums.opensuse.org/pre-release-beta/415373-hd-speed.html
