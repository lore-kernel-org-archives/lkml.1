Return-Path: <linux-kernel-owner+w=401wt.eu-S1764812AbXKNVYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764812AbXKNVYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbXKNVYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:24:21 -0500
Received: from empbedex1.empirix.com ([12.38.203.54]:13580 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbXKNVYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:24:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Wed, 14 Nov 2007 16:12:21 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com>
In-Reply-To: <473B44CB.6010209@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgm8BfGy+LYypAzRlqMVmh3tUUhwwAEmdkA
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 21:12:28.0444 (UTC) FILETIME=[0FDAC5C0:01C82703]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have gotten it to boot from those hard-drives and it 
has the same behavior:

  	Copying a large file to the same partition (>150MEG) 
  	causes the system to hang (no I/O - no input/output - 
  	nothing - complete freeze - like a primary resource 
  	is locked up or interrupts got completely & totally 
  	turned off in an ISR and its pending for something?

Only way to get out of this is to power-cycle the box!

@#$@#$#@





-----Original Message-----

> ::: Can you give me exact details of how to set up and reproduce this?
> :::  -- Kernel version
> 
> 	Linux-2.6.23.1
> 
> 	NOTE: I am using ppc (arch/ppc instead of arch/powerpc)
> 
> :::  -- number/config/model of drives
> 
> 	2x250GIG Western Digital - 3 partitions (largest (/dev/sda3
> 	~200Gig - formatted to ext2).
> 
> 	7042 PEX on a MPC8548 Board
> 
> :::  -- exact command line sequence to cause the failure
> 
> 	NFS mount root file system (I am currently rebuild to take away
> 	the NFS file system dependency) - /dev/sda3 is drive in
question...
..

MMmm.. I'd like to see that again without the rootfs-on-NFS.

What exactly do you mean when you say "it just hangs" ?
Everything (dead system)?


-
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
