Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbXKNSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbXKNSJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXKNSJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:09:10 -0500
Received: from [12.38.203.54] ([12.38.203.54]:1700 "EHLO empbedex1.empirix.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXKNSJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:09:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Wed, 14 Nov 2007 13:09:04 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com>
In-Reply-To: <473B36D7.8000205@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgm58NgojNR43GaQ8qdaQhf0hmh3AAAB2UA
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 18:09:07.0786 (UTC) FILETIME=[72F392A0:01C826E9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Mark Lord [mailto:liml@rtr.ca] 
Sent: Wednesday, November 14, 2007 12:57 PM
To: Morrison, Tom
Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations

Morrison, Tom wrote:
> 
<snip >
> The problem comes ONLY when I am doing large file operations 
> (e.g.: just copying a file) to/from the SATA drives behind 
> the subject line 7042....it just hangs after about 10-15 
> seconds into the copy...
> 
> How large a file causes the hang - you ask - well, somewhere 
> between 100Meg & 500Meg...
> 
<snip other drivel>


::: Can you give me exact details of how to set up and reproduce this?
:::  -- Kernel version

	Linux-2.6.23.1

	NOTE: I am using ppc (arch/ppc instead of arch/powerpc)

:::  -- number/config/model of drives

	2x250GIG Western Digital - 3 partitions (largest (/dev/sda3
	~200Gig - formatted to ext2).

	7042 PEX on a MPC8548 Board

:::  -- exact command line sequence to cause the failure

	NFS mount root file system (I am currently rebuild to take away
	the NFS file system dependency) - /dev/sda3 is drive in
question...

		a) mount /dev/sda3 /mnt/src 
		b) cp large_500Meg_file /mnt/src/.

==========================================================
==========================================================
NOTE: this does NOT fail on a 2.6.11 kernel version!!!!
	So I do NOT think it's a hardware problem!

	It could be a PEX related problem with arch/ppc - I would
	expect under heavy pounding with smaller files it would
	fail as well - but it does NOT)
==========================================================
==========================================================

Anything else you need to know?

