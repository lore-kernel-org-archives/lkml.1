Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZLRNg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZLRNg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZLRNgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:36:23 -0500
Received: from hmcexedge02.ikoula.com ([78.24.135.22]:7487 "EHLO
	mail.hmc.ikoula.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751085AbZLRNgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:36:22 -0500
From: Romain Kubany <rkubany@ikoula.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Fri, 18 Dec 2009 14:36:18 +0100
Subject: RE: Possible regression of LBA48 support for piix
Thread-Topic: Possible regression of LBA48 support for piix
Thread-Index: Acp/HfW6yWhn+IaPTzq4Ca/2Crcl5AAAjkkg
Message-ID: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB416@HMCEXMBX01CLUS.hmcikoula.com>
References: <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB2AF@HMCEXMBX01CLUS.hmcikoula.com>
 <A9C151C7BD19EC47976D4AA14CF277A8BC64DFB31D@HMCEXMBX01CLUS.hmcikoula.com>
 <4B2A227E.2010106@garzik.org> <200912171433.39135.bzolnier@gmail.com>
In-Reply-To: <200912171433.39135.bzolnier@gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Sorry, some kind of emergency occured and I didn't had the time to answer your mails

Jeff : No change were made to the VM configuration between the two kernel (2.6.27.41 & 2.6.28) so it is unlikely the disk himself or the VM configuration which are provoking this behavior.
Also, not this virtual machine in particular but others (with the same hardware configuration) are running Windows 2003/2008 without that limitation to 136Gb.

Bartlomiej : Ok, here is the dmesg of a 2.6.32.1 (http://pastebin.com/f3645803b ) and here is the output of a 'hdparm --Istdout /dev/sda' (under 2.6.32) as you suggested :

# hdparm --Istdout /dev/sda

/dev/sda:
045a 3fff 0000 0010 fe00 0200 003f abcd
dcba 0123 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 0003 0080 0000 312e
312e 3020 2020 5669 7274 7561 6c20 4844
2020 2020 2020 2020 2020 2020 2020 2020
2020 2020 2020 2020 2020 2020 2020 8080
0000 0f00 0000 0200 0200 0003 ffff 0010
00ff f010 0fef 0180 f010 0fef 0007 0407
0003 0078 0078 014d 0078 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0400 0000 0000 0400 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 1900 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000



-----Message d'origine-----
De : linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] De la part de Bartlomiej Zolnierkiewicz
Envoyé : jeudi 17 décembre 2009 14:34
À : Jeff Garzik
Cc : Romain Kubany; Mikael Pettersson; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
Objet : Re: Possible regression of LBA48 support for piix

On Thursday 17 December 2009 01:22:22 pm Jeff Garzik wrote:
> On 12/17/2009 07:07 AM, Romain Kubany wrote:
> > Here it is under the 2.6.28 :
> >
> > # hdparm -I /dev/sda
> >
> > /dev/sda:
> >
> > ATA device, with non-removable media
> >          Model Number:       Virtual HD
> >          Serial Number:
> >          Firmware Revision:  1.1.0
> > Standards:
> >          Likely used: 2
> > Configuration:
> >          Logical         max     current
> >          cylinders       16383   65535
> >          heads           16      16
> >          sectors/track   63      255
> >          --
> >          bytes/track: 65024      bytes/sector: 512
> >          CHS current addressable sectors:  267382800
> >          LBA    user addressable sectors:  267382800
> >          device size with M = 1024*1024:      130558 MBytes
> >          device size with M = 1000*1000:      136899 MBytes (136 GB)
> 
> Yeah, that info is straight from the virtual disk, without any sort of 
> massaging.  The disk is reporting 136GB max, so I would poke around 
> Windows to see if a setting changed somewhere...  maybe there is an "old 
> IDE compatible" setting that got turned on, for the virtual hd?

It is also possible that this virtual disk has never worked with ata_piix
driver and worked with piix driver in the older kernels because of pure luck.

In 2.6.28 I've fixed LBA48 checks in IDE to match libata (see commit 942dcd8
for details) so it would be worth to try:

	- simulating the older buggy IDE behavior with 2.6.32 kernel

or

	- staring long enough at 'hdparm --Istdout /dev/sda' output

first.

--
Bartlomiej Zolnierkiewicz
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

