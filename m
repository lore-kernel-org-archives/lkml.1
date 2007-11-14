Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXKNSbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXKNSbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXKNSax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:30:53 -0500
Received: from rtr.ca ([76.10.145.34]:4837 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbXKNSaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:30:52 -0500
Message-ID: <473B3ED9.40707@rtr.ca>
Date: Wed, 14 Nov 2007 13:30:49 -0500
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
..
> ::: Can you give me exact details of how to set up and reproduce this?
> :::  -- Kernel version
> 
> 	Linux-2.6.23.1
> 
> 	NOTE: I am using ppc (arch/ppc instead of arch/powerpc)
..

Okay.  Is that 32-bit or 64-bit?  How much RAM ?

My PPC machine is not currently set up for Linux,
and has only PCIX (not PCIe) slots, so I'll try this
first on an x86-32 box with PCIe.

If it works for me there, then I may be able to try
a PCIX card in my PPC-32 box later.  The PCIX card
won't have a 7042 of course, so I'll use a 6081 instead.
Those earlier Marvell chips are supposed to be extremely similar.

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
> question...
> 
> 		a) mount /dev/sda3 /mnt/src 
> 		b) cp large_500Meg_file /mnt/src/.
> 
> ==========================================================
> ==========================================================
> NOTE: this does NOT fail on a 2.6.11 kernel version!!!!
> 	So I do NOT think it's a hardware problem!
> 
> 	It could be a PEX related problem with arch/ppc - I would
> 	expect under heavy pounding with smaller files it would
> 	fail as well - but it does NOT)
> ==========================================================
> ==========================================================
> 
> Anything else you need to know?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

