Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbXEIKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbXEIKbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbXEIKba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:31:30 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:57419 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbXEIKb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:31:28 -0400
Date: Wed, 9 May 2007 12:31:04 +0200
From: Wouter Verhelst <wouter@debian.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Philippe De Muyter <phdm@macqel.be>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: retry [PATCH] partition : add support for sysv68 partitions
Message-ID: <20070509103104.GA31559@grep.be>
References: <20070413135501.GA27439@ingate.macqel.be> <Pine.LNX.4.64.0705082217340.12497@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705082217340.12497@anakin>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: The Debian Project, http://www.debian.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:21:12PM +0200, Geert Uytterhoeven wrote:
> 	Hi Philippe,
> On Fri, 13 Apr 2007, Philippe De Muyter wrote:
> > Add support for the Motorola sysv68 disk partition table (slices in motorola
> > doc).
> > 
> > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > 
> > diff -r 1b54f1d81bc5 fs/partitions/Kconfig
> > --- a/fs/partitions/Kconfig	Thu Apr 12 15:44:52 2007 -0700
> > +++ b/fs/partitions/Kconfig	Fri Apr 13 15:51:58 2007 +0200
> > @@ -236,3 +236,12 @@ config EFI_PARTITION
> >  	help
> >  	  Say Y here if you would like to use hard disks under Linux which
> >  	  were partitioned using EFI GPT.
> > +
> > +config SYSV68_PARTITION
> > +	bool "SYSV68 partition table support" if PARTITION_ADVANCED
> > +	default y if M68K
>         ^^^^^^^^^^^^^^^^^
> > +	help
> > +	  Say Y here if you would like to be able to read the hard disk
> > +	  partition table format used by Motorola Delta machines (using
> > +	  sysv68).
> > +	  Otherwise, say N.
> 
> Bummer, I saw your patch before, but I never noticed the `default y if M68K'.
> 
> Can you please tell me on which platforms SYSV68 partition tables are commonly
> used (I guess the Motorola MVME boards?), 

I guess so. I have a disk for my MVME167 lying around here somewhere
with SYSV/68 on it. If you want, I can verify what exact machines it
runs on, but I guess "every 68k MVME" is a safe enough bet.

-- 
Shaw's Principle:
	Build a system that even a fool can use, and only a fool will
	want to use it.
