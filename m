Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbXF3BIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbXF3BIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 21:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXF3BIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 21:08:01 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:49843 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbXF3BIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 21:08:00 -0400
Date: Sat, 30 Jun 2007 04:08:22 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Frank Fiene <ffiene@veka.com>
Cc: linux-kernel@vger.kernel.org, tytso@thunk.org
Subject: Re: Kernel doesn't recognize complete memory
Message-ID: <20070630010822.GP4504@mea-ext.zmailer.org>
References: <200706292225.26503.ffiene@veka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706292225.26503.ffiene@veka.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 10:25:26PM +0200, Frank Fiene wrote:
> Lenovo Z61p, Intel Core2 Duo T7200
> 
> I have 4GB RAM installed and BIOS recognize 4GB RAM.
> Linux kernel (Ubuntu-7.04, 32bit-PAE and 64bit, openSUSE-10.2 32bit-PAE 
> and 64bit) tells me: only 3GB of RAM are installed.

With AMD's Athlon64 the answer would be "look into BIOS settings,
(re)map 3-4 GB memory above 4 GB address mark"..

The PCI-bus and all IO devices in it needs memory space within
the first 4 GB of physical address space.  Some devices support
64-bit addresses in which case they can access whole physical
memory, most probably don't, meaning that they can access only
memory in lowest 4 GB part of the space.

Original 8088 PC had 20 bit address space, and "huge" megabyte
of address space. Then came 286 AT era with 24 bit addresses
and "whopping" 16 megabyte address space..  then came 386 and
finally true 32-bit addresses -- but ISA-space VGA aperture had
to be in there still..  and to gain access to of that memory
located "under" that VGA aperture, there was mapping...

Now the VGA aperture mapping is no more, but the PCI has similar
requirements - albeit with bigger apertures.


So, what does your BIOS have hidden in "advanced" menus (most likely) ?
Something about "remap (PCI?) memory above 4 GB" ?


> Any other user with a 4GB Thinkpad? tytso?
> 
> What can i do? Please help!
> 
> Regards
> Frank

Regards, Matti Aarnio
