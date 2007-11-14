Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbXKNS4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbXKNS4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXKNS4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:56:14 -0500
Received: from rtr.ca ([76.10.145.34]:2097 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXKNS4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:56:13 -0500
Message-ID: <473B44CB.6010209@rtr.ca>
Date: Wed, 14 Nov 2007 13:56:11 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morrison, Tom wrote:
> -----Original Message-----
> From: Mark Lord [mailto:liml@rtr.ca] 
> Sent: Wednesday, November 14, 2007 12:57 PM
> To: Morrison, Tom
> Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations
> 
> Morrison, Tom wrote:
> <snip >
>> The problem comes ONLY when I am doing large file operations 
>> (e.g.: just copying a file) to/from the SATA drives behind 
>> the subject line 7042....it just hangs after about 10-15 
>> seconds into the copy...
>>
>> How large a file causes the hang - you ask - well, somewhere 
>> between 100Meg & 500Meg...
>>
> <snip other drivel>
> 
> 
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
> 	the NFS file system dependency) - /dev/sda3 is drive in question...
..

MMmm.. I'd like to see that again without the rootfs-on-NFS.

What exactly do you mean when you say "it just hangs" ?
Everything (dead system)?


