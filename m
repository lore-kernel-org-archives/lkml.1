Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbXBMMcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbXBMMcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXBMMcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:32:39 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:57774 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbXBMMci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:32:38 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Tue, 13 Feb 2007 13:32:34 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <200702131034.22639.fink@mpe.mpg.de> <20070213112527.59eaa504@localhost.localdomain>
In-Reply-To: <20070213112527.59eaa504@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131332.34899.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. Februar 2007 12:25 schrieben Sie:
> > Well they do. The Flash disk I have (SATA-I) is capable of 48 MB/s and 
this 
> > value is reached over the whole disk size by windows as well as by 
FreeBSD. 
> > See my test results in the first thread.
> 
> Ok a flash disk should be more stable
> 
> > My Seagate Barracuda Harddisk drive (SATA-II) starts with 76 MB/s and 
> > decreases linearly to 35 MB/s due to the fact that it has to write to a 
> > rotating disk. But on a flash disk there is nothing rotating...
> 
> The hard disk one isn't guaranteed or stable but the flash especially if
> it is aimed at it ought to behave.
> 
> > So where is the difference between SATA-I and SATA-II ?
> 
> All physical side if they are on the same controller when you do the
> tests. Mostly latency,
> 
> > And why is FreeBSD able to write with constant rates (the complete 25 GB, 
all 
> > with 48+/-0.1 MB/s) but Linux 2.6.18 not ?
> 
> Does the FreeBSD fsync sync to media ? Also what controller is being used
> here, and do you have EHCI USB support running ?
Manual of FreeBSD fsync says it syncs to media.

I used the same controller: Same computer, same harddisk. two partitions on 
the system disk, one for linux, one for freebsd.

EHCI:

ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: Product: EHCI Host Controller

AHCI

ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode

> 
> > With a dedicated (rotating) SATA II device, using the first 70% of disk 
space 
> > no problem -- tested ! With a SATA-I device only a problem with Linux 
2.6.18
> 
> I suspect the SATA-1 itself may not be the decider but something else -
> eg the hard disk using NCQ, which would cover up any latency related
> problems.
> 
> > Journaling of data: you are right, ext2 performs better than ext3.
> 
> And ext3 in writeback mode ought in theory (but practice is always
> harder ;)) be faster than ext2.
> 
> 

-- 
Dipl. Physiker
Martin Anton Fink
Max Planck Institute for extraterrestrial Physics
Giessenbachstrasse
85741 Garching
Germany
Tel. +49-(0)89-30000-3645
Fax. +49-(0)89-30000-3569
