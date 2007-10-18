Return-Path: <linux-kernel-owner+w=401wt.eu-S1765005AbXJRRcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765005AbXJRRcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbXJRRcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:32:45 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:53211 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbXJRRcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:32:45 -0400
From: Nick Warne <nick@ukfsn.org>
Reply-To: nick@ukfsn.org
To: linux-kernel@vger.kernel.org
Subject: New CD/DVD drive - 80-wire cable detection failure
Date: Thu, 18 Oct 2007 18:32:42 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181832.42906.nick@ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please CC, not subscribed.

kernel 2.6.23

My DVD/CDrom stopped reading DVD's, so I purchased a new one today.

Old:
Oct 10 21:01:01 linuxamd kernel:     ide0: BM-DMA at 0xd000-0xd007, BIOS 
settings: hda:DMA, hdb:DMA
Oct 10 21:01:01 linuxamd kernel:     ide1: BM-DMA at 0xd008-0xd00f, BIOS 
settings: hdc:DMA, hdd:DMA

Oct 10 21:01:01 linuxamd kernel: hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 
2048kB Cache, UDMA(66)
Oct 10 21:01:01 linuxamd kernel: Uniform CD-ROM driver Revision: 3.20

New:
Oct 18 17:32:20 linuxamd kernel:     ide0: BM-DMA at 0xd000-0xd007, BIOS 
settings: hda:DMA, hdb:DMA
Oct 18 17:32:20 linuxamd kernel:     ide1: BM-DMA at 0xd008-0xd00f, BIOS 
settings: hdc:DMA, hdd:DMA

Oct 18 17:32:20 linuxamd kernel: hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW 
drive, 2048kB Cache, UDMA(33)
Oct 18 17:32:20 linuxamd kernel: Uniform CD-ROM driver Revision: 3.20

For some reason the new drive produces:

hdd: TSSTcorp CDDVDW SH-S202J, ATAPI CD/DVD-ROM drive
hdd: drive side 80-wire cable detection failed, limiting max speed to UDMA33

I boot with hdd=ide-cd

How to debug this to find out what is going on?

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
