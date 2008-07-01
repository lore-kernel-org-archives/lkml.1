Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYGAGZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYGAGZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYGAGZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:25:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:53053 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYGAGZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:25:06 -0400
Subject: RE: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: John Williams <john.williams@petalogix.com>, grant.likely@secretlab.ca,
       linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       vapier.adi@gmail.com, arnd@arndb.de, matthew@wil.cx,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, will.newton@gmail.com, hpa@zytor.com,
       John Linn <linnj@xilinx.com>, monstr@seznam.cz, drepper@redhat.com,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080630033943.332471860046@mail171-va3.bigfish.com>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
	 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
	 <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com>
	 <1d3f23370806291702g4344a2f9lb62f85cbb475fca4@mail.gmail.com>
	 <20080630033943.332471860046@mail171-va3.bigfish.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 16:21:42 +1000
Message-Id: <1214893302.20711.102.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As for the copyright, I haven't been able to find much information on
> whether or not generated files are even copyrightable.  One might
> argue that they
> don't have sufficient 'creative value' to be copyrightable.  Or
> arguably, they are as copyrightable by the generator author as by the
> author or the .mhs file.
> I admit in this case, I've followed the safe route by claiming a
> copyright, which at least at Xilinx has significant precedent.

Also, thinking about your idea of sticking bits in BRAM etc...

what would be nice would be the ability to "merge" trees. We've been
talking about that multiple times, it would be useful at several levels:

 - We could provide pre-made DTs for known CPUs (ie, 440GP, 440GX,
405EX, ...)
 - Boards can then include that, and then "override" some properties
(clocks, PHY wiring, ...)
 - That could be done at the binary level too so that the BRAM contains
on "overlay" on top of the base ref. platform device-tree that comes
with the kernel for example.

This is slightly different between doing that in the .dts source via
some kind of #include vs. doing that by merging blobs but we could make
it be essentially be the same internally: The #include generates a blob
that is then "merged in".

Just random thoughts...

Ben.
 

