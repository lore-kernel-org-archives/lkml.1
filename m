Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbZKMXrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbZKMXrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932570AbZKMXrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:47:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:20143 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbZKMXrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:47:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Zd4Zi9QMjn8VOdxj3DrSnINYuEtzMq0MR8i7OgVtAAUYgZpLTz5KPOXVImDg71nmgT
         D+xEqJ1KnF8C/KCcNjxJcQBCRBKO4g7hnCKSFO4ECoGo8Jwgg/9JYlKuhv5byfcv4JBn
         QaxpSmVyGaYTJza88z2Qii9vCJcAoDUctt/fw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 00:46:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <4AFCC0D4.9020708@gmail.com> <200911131715.24377.bzolnier@gmail.com> <20091113182515.38fb3793@lxorguk.ukuu.org.uk>
In-Reply-To: <20091113182515.38fb3793@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200911140046.29450.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 19:25:15 Alan Cox wrote:
> > Fine but please update status of following host drivers that were
> > marked as "stable" prematurely by commit e3389cb first:
> > 
> > PATA_PDC_OLD: needs to be marked as EXPERIMENTAL (or just BROKEN)
> > - known reliability problems with UDMA
> 
> A few odd reports apparently linked to specific chip revs. It's at
> least as stable as the old IDE one which doesn't work on my hardware. I'd

Skipping the technical merit of the quoted text for the moment -- I find
the fact that you keep calling the present IDE host drivers (that many
developers helped to fix) as "old" ones or "buggy" ones rather degrading
for their (this includes me of course) hard work.

Especially given your complete lack of familiarity with post-2004 changes.

See for yourself, *50* mostly _trivial_ patches during *5* years:

[ "git log --follow --since="5 years ago" drivers/ide|grep "Author: Alan Cox" -B1 -A3"
  output edited for easier reading ]

commit d878829   piix: The Sony TZ90 needs the cable type hardcoding
commit ccd32e2   ide: Switch to a common address
commit 1bee4d1   pdc202xx_old: remove surplus initialiser
commit d3bad45   dtc2278: note on docs
commit 9702b5d   ide: Stop mapping ROMs
commit 7859557   ide: Fix a theoretical Ooops case
commit 2074a10   ide/pci/serverworks.c: Fix corruption/timeouts with MegaIDE
commit 640b31b   sl82c105: Switch to ref counting API
commit 846c11a   ide: remove a ton of pointless #undef REALLY_SLOW_IO
commit 8693d3e   siimage: DRAC4 note
commit fdb77da   ide-floppy: Fix unformatted media crash
commit 3e9e4c8   ide/generic: Jmicron has its own drivers now
commit ee2f344   [PATCH] ide-cd: Handle strange interrupt on the Intel ESB2
commit 6451956   [PATCH] ide: complete switch to pci_get
commit b148900   [PATCH] ide: more conversion to pci_get APIs
commit 23a1b2a   [PATCH] via82cxxx: handle error condition properly
commit c333526   [PATCH] JMB 368 PATA detection
commit 3a42bb2   [PATCH] ide: add sanity checking to ide taskfile ioctl
commit 3719bc5   [PATCH] ide-generic: jmicron fix
commit 652aa16   [PATCH] IDE: more pci_find cleanup
commit 913759a   [PATCH] ide: Fix crash on repeated reset
commit 5ac2469   [PATCH] ide: backport piix fixes from libata into the legacy..
commit bbb3bbd   [PATCH] non-libata driver for Jmicron devices
commit 40cddf2   [PATCH] sis5513: Switch to pci refcounting
commit 970a613   [PATCH] serverworks: Switch to pci refcounted interfaces
commit 1424e50   [PATCH] piix: Use refcounted interface when searching for a ..
commit 28a2a3f   [PATCH] Fix 2.6.18-rc6 IDE breakage, add missing ident neede..
commit a7dec1e   [PATCH] Missing PCI id update for VIA IDE
commit 79860a9   [PATCH] PATCH: 2.6.18 oops on boot fix for IDE
commit 15e0c69   [PATCH] ide: fix Jmicron support
commit faab17b   [PATCH] Fix problem with ATAPI DMA on IT8212 in Linux
commit 3706a87   [PATCH] Set err_stops_fifo for newer Promise as well
commit 57e834e   [PATCH] ide: clean up pdc202xx_old so its more readable (don..
commit f201f50   [PATCH] ide: housekeeping on IDE drivers
commit da574af   [PATCH] ide: fix error handling for drives which clear the F..
commit 2930d1b   [PATCH] SC1200 debug printk
commit 19c1ef5   [PATCH] ide: clean up siimage
commit 1a1276e   [PATCH] Old IDE, fix SATA detection for cabling
commit 4fb0f76   [PATCH] Fix IDE locking error
commit dbe217a   [PATCH] IDE CD end-of media error fix
commit d266ab8   [PATCH] Small fixes backported to old IDE SiS driver
commit 0c866b5   [PATCH] ide: set latency when resetting it821x out of firmwa..
commit d7d7634   [PATCH] ide: clean up the garbage in eighty_ninty_three
commit da9091e   [PATCH] ide: it8212 backport for Bartlomiej IDE
commit bb732d7   [PATCH] ide: fix crashes with hotplug serverworks
commit b39b01f   [PATCH] ide: fix the HPT366 driver layer
commit b189346   [PATCH] ide: ide-generic, allow for capture of other unsuppo..
commit 68ad991   [PATCH] ide: IDE timing violation on reset
commit 58ecd15   [PATCH] ide: samsung SN-124 works perfectly well with DMA
commit 6efd936   [PATCH] ide: fix ide-disk inability to handle LBA only devic..

Despite this it seems that at least LWN.net seems to treat your opinions with
completely undeserved seriousness..  Weird.

-- 
Bartlomiej Zolnierkiewicz
