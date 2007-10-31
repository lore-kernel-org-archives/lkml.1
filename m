Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbXJaQG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbXJaQG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbXJaQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:06:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56251 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbXJaQGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:06:49 -0400
Message-ID: <4728A816.8020608@garzik.org>
Date: Wed, 31 Oct 2007 12:06:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>
Subject: Re: Other Problems with Marvell Driver - 7042 (2.6.23)...
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Morrison, Tom wrote:
> I am running the 'latest' kernel retrieved from Kumar Gala's
> Powerpc git tree (mainly because I am running on a MPC8548 board) 
> and it appears to be in the full 2.6.23 version while the sata_mv 
> driver version seems to be 1.01. 
> 
> I have searched the archives, and there has been some discussion
> of a regression in the Marvell driver, but I seem to have a 
> different symptom from Olaf's (I am not running a 64bit kernel - 
> and I am *not* running with large (36bit) physical and resources - 
> so I wouldn't have the same type of IOMMU issues)
> 
> Below in the error output (using ATA_DEBUG) the driver sees the 
> two drives (3 partitions on /dev/sda & 2 partitions on /dev/sdb)
> and apparently sets up everything correctly for standard access...
> 
> But, when I try to mount a partition - it freezes up and gets I/O
> errors?
> Can someone give me any hints of things to try?

First you need to try 2.6.23.1 rather than 2.6.23, because it contains a 
critical sata_mv fix.

	Jeff



