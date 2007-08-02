Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXHBICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXHBICa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbXHBICQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:02:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXHBICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:02:14 -0400
Date: Thu, 2 Aug 2007 13:44:37 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: =?UTF-8?Q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>
cc: trivial@kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtdsuper: licensce = GPL
In-Reply-To: <46B18551.2020809@interia.pl>
Message-ID: <alpine.LFD.0.999.0708021309430.8258@enigma.security.iitk.ac.in>
References: <46B0D1F7.9090805@interia.pl> <alpine.LFD.0.999.0708020318070.8258@enigma.security.iitk.ac.in>
 <46B18551.2020809@interia.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-541684149-1186040538=:8258"
Content-ID: <alpine.LFD.0.999.0708021318350.8258@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-541684149-1186040538=:8258
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.0.999.0708021318351.8258@enigma.security.iitk.ac.in>

Hi,


On Thu, 2 Aug 2007, Rafał Bilski wrote:

> > > block2mtd: version $Revision: 1.30 $
> > > block2mtd: mtd0: [d: /dev/sdc2] erase_size = 64KiB [65536]
> > > mtdsuper: module license 'unspecified' taints kernel.
> > > mtdsuper: Unknown symbol get_mtd_device
> > > mtdsuper: Unknown symbol put_mtd_device
> > > jffs2: Unknown symbol get_sb_mtd
> > > jffs2: Unknown symbol kill_mtd_super
> > 
> > That's weird. I'm wondering how did you manage to build mtdsuper as a
> > separate module in the first place? It always gets linked with mtdcore
> > (which has all the necessary module decoration stuff) into the "mtd"
> > module itself, at least that;s what the Makefile says ...
> 
> I don't know. Just "make oldconfig" (~2.6.21) and "make". I have mtdcore as a
> separate module too. That's weird: /Makefile claims that it is 2.6.22.1, but
> looking at the sources I see changes present in 2.6.23-rc1. I have downloaded
> 2.6.22.1 in the first place and patched it with -rc1 and -rc1-git3 patch. 

You should apply -rcN or -gitX patches on the previous Linus' kernel
(2.6.x) and not the 2.6.x.y "-stable" ones -- those are a "parallel" tree.

> # ls *.ko
> ftl.ko  mtd_blkdevs.ko  mtdblock.ko  mtdchar.ko  mtdcore.ko  mtdpart.ko
> mtdsuper.ko

Hmm, you've got mtdpart build separately as well. Could you redo as per
what I suggested above (take 2.6.22, apply -rc1, then -rc1-git3) and then
rebuild after "make oldconfig" ... and let us know if you still end up
with these modules? Could also be a make/toolchain issue at your end,
for all I know.


Satyam
--464262402-541684149-1186040538=:8258--
