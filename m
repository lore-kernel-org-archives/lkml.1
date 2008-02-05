Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYBEQk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYBEQk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYBEQkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:40:15 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:10210 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYBEQkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:40:14 -0500
Date: Tue, 5 Feb 2008 08:40:12 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-driver@qlogic.com
Subject: Re: 2.6.24 regression w/ QLA2300
Message-ID: <20080205164012.GI19882@plap3.qlogic.org>
References: <47A88736.6090706@hp.com> <20080205160246.GF19882@plap3.qlogic.org> <47A88F2C.5050407@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A88F2C.5050407@hp.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 05 Feb 2008 16:40:13.0744 (UTC) FILETIME=[C7E69B00:01C86815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008, Alan D. Brunelle wrote:

> > and send the resultant kernel logs?
> 
> Here's the output to the console (if there are other logs you need,
> let me know). I'll try the patch next, and sorry, hadn't realized
> merges were still coming in under 2.6.24 in Linus' tree... 
> 
> QLogic Fibre Channel HBA Driver
> ACPI: PCI Interrupt 0000:40:01.0[A] -> GSI 38 (level, low) -> IRQ 58
> qla2xxx 0000:40:01.0: Found an ISP2312, irq 58, iobase 0xc0000000a0041000
> qla2xxx 0000:40:01.0: Configuring PCI space...
> qla2x00_get_flash_version(): Unrecognized code type ff at pcids da1c.
> qla2x00_get_flash_version(): Unrecognized code type ff at pcids 1f61c.
> qla2xxx 0000:40:01.0: Configure NVRAM parameters...
> qla2xxx 0000:40:01.0: Verifying loaded RISC code...
> scsi(14): **** Load RISC code ****
> scsi(14): Verifying Checksum of loaded RISC code.
> scsi(14): Checksum OK, start firmware.
> qla2xxx 0000:40:01.0: Allocated (412 KB) for firmware dump...
> scsi(14): Issue init firmware.
> qla2x00_mailbox_command(14): **** FAILED. mbx0=4001, mbx1=0, mbx2=ba8a, cmd=48 ****

Ok, this is what I would have expected with the linus' tree prior to
the fix.  I just double-checked, the fix in question has yet to make
it's way to Linus' tree.  It's currently in scsi-misc-2.6:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a571fdf7caa010e17f6a70c0c52e0992e87af7db

which should filter up to linux-2.6.git during Linus' next pull.

thanks, av
