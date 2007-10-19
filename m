Return-Path: <linux-kernel-owner+w=401wt.eu-S966790AbXJSVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966790AbXJSVH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765151AbXJSVHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:07:46 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:53147 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765034AbXJSVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:07:44 -0400
Date: Fri, 19 Oct 2007 17:07:43 -0400
To: Nick Warne <nick@ukfsn.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Message-ID: <20071019210743.GI4003@csclub.uwaterloo.ca>
References: <200710181832.42906.nick@ukfsn.org> <200710192049.07877.nick@ukfsn.org> <200710192228.43655.bzolnier@gmail.com> <200710192203.09835.nick@ukfsn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710192203.09835.nick@ukfsn.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 10:03:09PM +0100, Nick Warne wrote:
> No change:
> 
> ide_setup: hdd=ide-cd
>     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
> hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
> hdd: drive side 80-wire cable detection failed, limiting max speed to UDMA33
> hdd: selected mode 0x42
> hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)

Did you try another cable?  DId you try using both the old IDE drivers
and the new PATA libata drivers?  What is the hdd=ide-cd supposed to
do?  Do you have a device present as hdc and if not, then why not?
(Hint: ATA spec requires a master before you can have a slave, even
though it frequently does work with just a slave.  Of course cable
select seems even nicer since then the device at the end of an 80 wire
cable is automatically master, and any additional device added to the
middle connector on the cable becomes slave, and you should not connect
a device to the middle connector without one on the end).

Also make sure the right end of the cable is connected to the mainboard,
just in case that matters.

--
Len Sorensen
