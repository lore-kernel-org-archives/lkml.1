Return-Path: <linux-kernel-owner+w=401wt.eu-S967121AbXJSVMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967121AbXJSVMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966167AbXJSVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:12:33 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:53193 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762273AbXJSVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:12:32 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Date: Fri, 19 Oct 2007 22:12:30 +0100
User-Agent: KMail/1.9.7
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200710181832.42906.nick@ukfsn.org> <200710192203.09835.nick@ukfsn.org> <20071019210743.GI4003@csclub.uwaterloo.ca>
In-Reply-To: <20071019210743.GI4003@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710192212.30533.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 22:07:43 Lennart Sorensen wrote:
> On Fri, Oct 19, 2007 at 10:03:09PM +0100, Nick Warne wrote:
> > No change:
> >
> > ide_setup: hdd=ide-cd
> >     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
> > hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
> > hdd: drive side 80-wire cable detection failed, limiting max speed to
> > UDMA33 hdd: selected mode 0x42
> > hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
>
> Did you try another cable?  DId you try using both the old IDE drivers
> and the new PATA libata drivers?  What is the hdd=ide-cd supposed to
> do?  Do you have a device present as hdc and if not, then why not?
> (Hint: ATA spec requires a master before you can have a slave, even
> though it frequently does work with just a slave.  Of course cable
> select seems even nicer since then the device at the end of an 80 wire
> cable is automatically master, and any additional device added to the
> middle connector on the cable becomes slave, and you should not connect
> a device to the middle connector without one on the end).
>
> Also make sure the right end of the cable is connected to the mainboard,
> just in case that matters.

I have (since 2.6.15 at least) hda, hdb, hdc, and hdd.

hda and hdb are mounted at boot.  hdc is not mounted, as I leave that drive 
for backups and mount as needed.

All I done was replace a duff cd/dvd drive (hdd) with a new one.

Nick

-- 
Free Software Foundation Associate Member 5508
