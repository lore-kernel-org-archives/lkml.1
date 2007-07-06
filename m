Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbXGFOkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbXGFOkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXGFOkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:40:23 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38670 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbXGFOkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:40:21 -0400
Date: Fri, 06 Jul 2007 08:39:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PATA-disk named sda
In-reply-to: <fa.DRDWDh+VAXx84D/6XHgY6h2wB+E@ifi.uio.no>
To: Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <468E5420.7090605@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.VMMtK2yPXE5gkxuIC8MWb1aPBiQ@ifi.uio.no>
 <fa.23lYEA4r0kfTVDJ1AKcxSE4vGKA@ifi.uio.no>
 <fa.DRDWDh+VAXx84D/6XHgY6h2wB+E@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Pleger wrote:
> Hello,
> 
>>> In the newest Ubuntu Release, my PATA-disk is called sda instead of
>>> hda. Is that a general feature in newer kernel versions or is it a
>>> special feature in Ubuntu?
>> General. SATA and now PATA drives map onto the /dev/sd range as do
>> SCSI, USB etc
> 
> It seems to be not that simple, at least not if both the old IDE
> interface and the new libata interface are enabled as modules: In my
> Ubuntu system, I created two kernel packages (from the same kernel
> source and with the same configuration) and installed them. Afterwards,
> I re-created the initial ramdisks, one with the Ubuntu feisty utilities
> and one with Debian etch utilities. So, I had the same kernel with
> different ramdisks. With the Ubuntu ramdisk, my harddrive was named sda,
> but with the Debian ramdisk, it was named hda.
> 
> So, the name of the drive can depend on something which happens in the
> ramdisk environment. Does anybody know what that is? And is there a
> kernel command line parameter which restores the old behaviour?
> 
> And what about hdparm (setting 32bit I/O and multi-sector mode)? Suren
> wrote that 32bit I/O makes no sense when using DMA. Maybe that's right,
> but it does not correspond with my experiences. At least, I have the
> "feeling" that my IDE disks work much faster since I enabled 32bit
> support (DMA already was on before).

No, it has absolutely no effect in DMA mode.

Currently the DMA, multi-sector mode, etc. are not controllable with 
hdparm with libata. libata is designed to use the fastest settings 
possible by default. In a lot of cases this messing with hdparm was only 
needed because of stupidity with the old IDE code (like DMA not being 
automatically enabled if the low-level driver was built modular).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

