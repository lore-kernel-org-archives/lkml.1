Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXEUXwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXEUXwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbXEUXvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:51:47 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:40267 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159AbXEUXvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:51:46 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200705212351.l4LNpZjY010860@turbo.physics.adelaide.edu.au>
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
To: alan@lxorguk.ukuu.org.uk (Alan Cox)
Date: Tue, 22 May 2007 09:21:35 +0930 (CST)
Cc: jesse.barnes@intel.com, jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       hancockr@shaw.ca (Robert Hancock), linux-kernel@vger.kernel.org
In-Reply-To: <20070522001837.5104bfe1@the-village.bc.nu> from "Alan Cox" at May 22, 2007 12:18:37 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device
> > 6101 (rev b1) (prog-if 8f [Master SecP SecO PriP PriO]) Subsystem:
> > Marvell Technology Group Ltd. Unknown device 6101 Flags: bus master,
> > fast devsel, latency 0, IRQ 10
> :
> Looks like you've got Marvell IDE for your PATA stuff (my board is the 
> same).  Try the latest Marvell driver, it seems to drive my machine ok.  
> For older kernels, I think you can pass 'all-generic-ide' on the boot 
> line to get the old IDE layer to drive the device.

Oh dear, would you believe I totally missed this entry in a dozen runs
though the output yesterday?  A fresh pair of eyes always helps.

> This would be your PATA port - pata_marvell.

Are we talking CONFIG_PATA_MARVELL here?  If so then the kernel I just
booted has this set to "y" (ie: built-in) and yet the drive is still not
detected.  Is there a newer version of this driver somewhere?  The kernel
was 2.6.22-rc2.

Regards
  jonathan
--
"Time is an illusion; lunchtime doubly so"
