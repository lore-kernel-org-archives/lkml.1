Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbXBXSpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbXBXSpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 13:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXBXSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 13:45:20 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:49559 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbXBXSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 13:45:19 -0500
Date: Sat, 24 Feb 2007 13:45:16 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: why is asm-parisc/ioctl.h subtly different from asm-generic/ioctl.h?
Message-ID: <20070224184516.GA6755@athena.road.mcmartin.ca>
References: <Pine.LNX.4.64.0702240530190.11865@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702240530190.11865@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 05:34:15AM -0500, Robert P. J. Day wrote:
> 
>   just noticed that parisc's ioctl.h file, rather than simply
> including asm-generic/ioctl.h, has its own copy whose sole
> (meaningful) difference from the generic one is:
> 
> $ diff include/{asm-generic,asm-parisc}/ioctl.h
> ...
> 41,42c54,55
> < #define _IOC_WRITE    1U
> < #define _IOC_READ     2U
> ---
> > #define _IOC_WRITE    2U
> > #define _IOC_READ     1U
> 
>  so parisc is identical except that it switches the meaning of the
> direction field?  is there a reason for this?  just curious.
> 

HP-UX compatibility.

#define IOC_OUT 0x40000000
#define IOC_IN (int)0x80000000

PS: It would be wise to ask questions on the pertinent mailing lists...

--Kyle
