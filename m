Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXGFMbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXGFMbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 08:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXGFMa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 08:30:57 -0400
Received: from waldorf.cs.uni-dortmund.de ([129.217.4.42]:51883 "EHLO
	waldorf.cs.uni-dortmund.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbXGFMa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 08:30:56 -0400
Date: Fri, 6 Jul 2007 14:30:55 +0200
From: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
To: linux-kernel@vger.kernel.org
Subject: Re: PATA-disk named sda
Message-Id: <20070706143055.01aa9ef6.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706111848.43551f33@the-village.bc.nu>
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
	<20070706111848.43551f33@the-village.bc.nu>
Organization: Universitaet Dortmund
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; sparc-sun-solaris2.8)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > In the newest Ubuntu Release, my PATA-disk is called sda instead of
> > hda. Is that a general feature in newer kernel versions or is it a
> > special feature in Ubuntu?
> 
> General. SATA and now PATA drives map onto the /dev/sd range as do
> SCSI, USB etc

It seems to be not that simple, at least not if both the old IDE
interface and the new libata interface are enabled as modules: In my
Ubuntu system, I created two kernel packages (from the same kernel
source and with the same configuration) and installed them. Afterwards,
I re-created the initial ramdisks, one with the Ubuntu feisty utilities
and one with Debian etch utilities. So, I had the same kernel with
different ramdisks. With the Ubuntu ramdisk, my harddrive was named sda,
but with the Debian ramdisk, it was named hda.

So, the name of the drive can depend on something which happens in the
ramdisk environment. Does anybody know what that is? And is there a
kernel command line parameter which restores the old behaviour?

And what about hdparm (setting 32bit I/O and multi-sector mode)? Suren
wrote that 32bit I/O makes no sense when using DMA. Maybe that's right,
but it does not correspond with my experiences. At least, I have the
"feeling" that my IDE disks work much faster since I enabled 32bit
support (DMA already was on before).

Regards
  Christoph
