Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYAEESu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYAEESu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 23:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYAEESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 23:18:41 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:13206 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYAEESk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 23:18:40 -0500
X-IronPort-AV: E=Sophos;i="4.24,247,1196661600"; 
   d="scan'208";a="518452169"
Date: Fri, 4 Jan 2008 22:18:28 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Querying the bios from booted linux kernel?
Message-ID: <20080105041828.GB6011@auslistsprd01.us.dell.com>
References: <200801041913.54030.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801041913.54030.gene.heskett@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 07:13:53PM -0500, Gene Heskett wrote:
> Greetings;
> 
> Is there a utility that can query the motherboard bios and get a list of the 
> drives it can see?
> 
> Likewise, for the bios extension contained on a pny sata card with a Silicon 
> Image chipset on it?
> 
> I'm trying to cobble up a way for linux to boot from the drive on this sata 
> card, so that the F8 install is completely separated from the FC6 install on 
> a pata drive connected to the mainboard.

parted and fdisk both write into the MBR signature space, so your
disks should have unique MBR values in them.

Then, F8 anaconda / kickstart can be told on which disk to write its
bits.  http://linux.dell.com/installermagic.shtml  describes this.


I've given up trusting any BIOS to get EDD 3.0 device paths right,
there are just too many broken implementations out there, and
seemingly no real desire on the part of the component vendors to fix
it.  MBR signatures work pretty well - Dell uses this method for every
one of our factory installed Linux systems we ship, so I _know_ it works.


-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
