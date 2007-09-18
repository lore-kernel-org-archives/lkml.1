Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbXIRXmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbXIRXmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXIRXmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:42:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49192 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbXIRXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:42:13 -0400
Date: Wed, 19 Sep 2007 05:14:59 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
Message-ID: <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
 <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
 <1189121714.6672.38.camel@heimdal.trondhjem.org>
 <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Kyle Moffett wrote:
> 
> On Sep 06, 2007, at 19:35:14, Trond Myklebust wrote:
> > 
> > On Thu, 2007-09-06 at 19:30 -0400, Kyle Moffett wrote:
> > > 
> > > On Sep 06, 2007, at 11:06:16, J. Bruce Fields wrote:
> > > > The question of how to protect against someone with *physical*
                                               ^^^^^^^^^^^^^^^^^^^^^^^
> > > > access certainly is more difficult, but surely that's a separate
        ^^^^^^

> > > > problem.
> > > 
> > > Actually, that's a fairly simple problem (barring disassembling the system
                                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > > and attaching a hardware debugger).  You encrypt the root filesystem and
> > > require a password to boot (See: LUKS).  Debian has built-in support for
> > > installing onto fs-on-LVM-on-crypt-on-RAID, and it works quite well on all
> > > the laptops I use regularly.  It's not even much of a speed penalty; once
> > > you take the overhead of hitting a 5400RPM laptop drive you can chew
> > > thousands of cycles of CPU without anybody noticing (much).  Then all you
> > > have to do is burn a copy of your /boot with bootloader onto some
> > > read-only media (like a finalized CDROM/DVDROM) and you're set to go.
> > 
> > Disconnect battery, and watch boot password go 'poof!'.
> 
> Umm, I did say "encrypt the root filesystem", didn't I?  Booting my laptops
                                                                      ^^^^^^^

The whole *point* here is to secure against physical access -- then how
can you assume "barring disassembling the system"? If you're not
considering attacks such as those, then how _are_ you solving the
physical access problem in the first place? :-)


> this way follows this procedure:
>  1) Enter BIOS boot menu
>  2) Insert /boot CDROM
>  3) Select the "CDROM" entry
>  4) Wait for kernel to start and run through initramfs
>  5) Type password into the initramfs prompt so that it can DECRYPT THE ROOT
> FILESYSTEM
>  6) Continue to boot the system.
> 
> Under this setup, tinkering with my BIOS does virtually nothing; the only
> avenues of attack are strictly of the "Install a hardware keylogger" variety.

Doesn't flashing/replacing your BIOS firmware/chip count as tinkering?
Then I don't really need a "hardware keylogger", do I ...
