Return-Path: <linux-kernel-owner+w=401wt.eu-S1761543AbZD0UsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761543AbZD0UsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 16:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760216AbZD0Ury
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 16:47:54 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49044 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759738AbZD0Ury (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 16:47:54 -0400
Date: Mon, 27 Apr 2009 15:47:52 -0500
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@freescale.com>
Cc: David Hawkins <dwh@ovro.caltech.edu>, linuxppc-dev@ozlabs.org,
       Dan Williams <dan.j.williams@intel.com>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
Message-ID: <20090427204752.GA22406@ld0162-tx32.am.freescale.net>
References: <20090424183517.GB23140@ovro.caltech.edu> <D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net> <ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com> <49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com> <49F60BF8.8040404@ovro.caltech.edu> <49F60FE1.90707@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F60FE1.90707@freescale.com>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 03:04:49PM -0500, Timur Tabi wrote:
> David Hawkins wrote:
> 
> > Can you give me an example of non-PCI memory that would be
> > non-prefetchable that you'd like us to try? We can see if our
> > host CPUs have an area like that ... we just need to know
> > what device to look for first :)
> 
> Hmmmm.... I was going to say any SOC device in the IMMR, but I don't see
> anything there that would constitute a memory buffer.
> 
> I test this change on an 8610 and DMA to a register I/O, where this bit
> isn't even defined, and it made no difference.  So I guess this change
> is okay.

I thought the driver only used the bit if the device tree indicated it
was an 83xx-era DMA controller?

That said, the bits are documented as specifically for PCI, so it would
be surprising if it had any effect elsewhere.

-Scott
