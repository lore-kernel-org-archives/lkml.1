Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZFVRVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZFVRVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZFVRVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:21:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbZFVRVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:21:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared - system 
 =?iso-8859-1?q?=09is_dreadfully?= slow)
Date: Mon, 22 Jun 2009 19:21:20 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Greg Freemyer <greg.freemyer@gmail.com>,
       David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       elendil@planet.nl, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090621.141950.160759111.davem@davemloft.net> <4A3FB956.6060401@garzik.org> <20090622181100.43a56309@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622181100.43a56309@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906221921.21709.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+dDz/SroXpTlxULXwMb1voRmsn1koYke4Xfa5
 Noy4kqyt+yjDPvD2e+WcwjIaQhfUTcJpYNicPzz1ChNg22TRa1
 o8vIvMHlxQ00e3yvgjqT49Urj8vr79R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Alan Cox wrote:
> sgiioc4 is another obvious "modern machine" case. The rest are pretty
> obscure (eg mac68K drivers and IDE VLB drivers most of which don't
> actually work in the old IDE code even though there is code)

Actually, m68k, m32r and h8300 currently can't use libata at all
for one reason or another, mostly missing support for dma-mapping.h

Microblaze and the upcoming S+Core also lack DMA support right
now, but that should get rectified soon.

You could argue that still all of these fall into the 'obscure'
category, of course. With just a little effort on the architecture
side, it should be possible to convert almost any non-PCI ATA
chip to use drivers/ata/pata_platform.c or pata_of_platform.c.

	Arnd <><
