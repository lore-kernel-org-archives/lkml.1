Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXCJKNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXCJKNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXCJKNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:13:05 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:59948 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXCJKND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:13:03 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 05:10:29 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Armin Schindler <armin@melware.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead(?) header files in the source tree
In-Reply-To: <Pine.LNX.4.61.0703101106270.30274@phoenix.one.melware.de>
Message-ID: <Pine.LNX.4.64.0703100508570.27526@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703091633350.29697@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0703101106270.30274@phoenix.one.melware.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Armin Schindler wrote:

> On Fri, 9 Mar 2007, Robert P. J. Day wrote:
> >
> >   following up on an earlier post by stefan richter, i wrote a
> > brute-force little script that scanned the source tree, looking for
> > header files that weren't included from *anywhere* in the tree.  what
> > turned up was the following:
> >
> > ./arch/m68k/atari/atasound.h
> > ./arch/arm/mach-s3c2410/bast.h
> > ./arch/ppc/syslib/cpc710.h
> > ./arch/um/kernel/tt/include/mode_kern-tt.h
> > ./arch/powerpc/platforms/83xx/mpc834x_itx.h
> > ./drivers/serial/crisv10.h
> > ./drivers/isdn/hardware/eicon/dbgioctl.h
> > ./drivers/char/digi.h
> > ./drivers/message/i2o/i2o_lan.h
> > ./drivers/net/wan/lmc/lmc_media.h
> > ./drivers/net/skfp/h/lnkstat.h
> > ./drivers/isdn/hardware/eicon/main_if.h
> > ./drivers/message/fusion/lsi/mpi_inb.h
> > ./drivers/message/fusion/lsi/mpi_log_fc.h
> > ./drivers/video/riva/nv4ref.h
> > ./drivers/scsi/pci2000.h
> > ./drivers/char/drm/via_mm.h
> > ./drivers/net/chelsio/vsc8244_reg.h
> > ./include/linux/elfnote.h
> > ./sound/pci/au88x0/au88x0_sb.h
> > ./sound/pci/cs46xx/imgs/cwcemb80.h
> >
> >   this list represents an absolute *minimum* of what are apparently
> > orphaned header files, in that they are not referenced from *anywhere
> > else* in the tree, not even from include directives that are
> > currently commented out.  in short, they are truly homeless (assuming
> > i didn't screw up my programming, that is).
> >
> >   anyone want to get rid of some of them?
>
> Yes. For my part, the file
>
>   ./drivers/isdn/hardware/eicon/main_if.h
>
> should be removed.
>
> Shall I write a patch?

sure, feel free.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
