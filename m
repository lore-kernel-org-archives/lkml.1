Return-Path: <linux-kernel-owner+w=401wt.eu-S1766792AbXCIV7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766792AbXCIV7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767555AbXCIV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:59:12 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:40359 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766792AbXCIV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:59:10 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 16:43:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead(?) header files in the source tree
Message-ID: <Pine.LNX.4.64.0703091633350.29697@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  following up on an earlier post by stefan richter, i wrote a
brute-force little script that scanned the source tree, looking for
header files that weren't included from *anywhere* in the tree.  what
turned up was the following:

./arch/m68k/atari/atasound.h
./arch/arm/mach-s3c2410/bast.h
./arch/ppc/syslib/cpc710.h
./arch/um/kernel/tt/include/mode_kern-tt.h
./arch/powerpc/platforms/83xx/mpc834x_itx.h
./drivers/serial/crisv10.h
./drivers/isdn/hardware/eicon/dbgioctl.h
./drivers/char/digi.h
./drivers/message/i2o/i2o_lan.h
./drivers/net/wan/lmc/lmc_media.h
./drivers/net/skfp/h/lnkstat.h
./drivers/isdn/hardware/eicon/main_if.h
./drivers/message/fusion/lsi/mpi_inb.h
./drivers/message/fusion/lsi/mpi_log_fc.h
./drivers/video/riva/nv4ref.h
./drivers/scsi/pci2000.h
./drivers/char/drm/via_mm.h
./drivers/net/chelsio/vsc8244_reg.h
./include/linux/elfnote.h
./sound/pci/au88x0/au88x0_sb.h
./sound/pci/cs46xx/imgs/cwcemb80.h

  this list represents an absolute *minimum* of what are apparently
orphaned header files, in that they are not referenced from *anywhere
else* in the tree, not even from include directives that are
currently commented out.  in short, they are truly homeless (assuming
i didn't screw up my programming, that is).

  anyone want to get rid of some of them?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
