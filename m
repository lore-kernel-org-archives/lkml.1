Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZCUMgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZCUMgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZCUMfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:35:54 -0400
Received: from ppp-110-39.adsl.restena.lu ([158.64.110.39]:56229 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZCUMfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:35:53 -0400
Date: Sat, 21 Mar 2009 13:35:50 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: phillip@lougher.demon.co.uk, linux-kernel@vger.kernel.org
Subject: Re: SquashFS io errors - zlib_inflate tried to decompress too much
  data
Message-ID: <20090321133550.7aa939d2@neptune.home>
In-Reply-To: <10f740e80903210511n2867e7adl11fda0f4af04b0d2@mail.gmail.com>
References: <20090321113315.47562aac@neptune.home>
	<10f740e80903210511n2867e7adl11fda0f4af04b0d2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Geert,

I saw that patch but somehow it slipped through when applying the
set of squashfs patches for my 2.6.28.8 install...
With that patch applied access to the image works as expected

Sorry for the noise,
Bruno


On Sat, 21 March 2009 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, Mar 21, 2009 at 11:33, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
> >
> > With 2.6.29-rc7-git5 (x86, 32bit) I get the following errors on
> > assumed correct squashfs images (generated with mksquashfs from
> > CVS, dated 2009-03-14)
> >
> > [ 3481.692558] SQUASHFS error: zlib_inflate tried to decompress too
> > much data, expected 8192 bytes.  Zlib data probably corrupt
> > [ 3481.692571] SQUASHFS error: squashfs_read_data failed to read
> > block 0x29375e0 [ 3481.692579] SQUASHFS error: Unable to read
> > metadata cache entry [29375e0] [ 3481.692586] SQUASHFS error:
> > Unable to read inode 0x6a04a05ed
> >
> > The same happens on 2.6.28.8 with all squashfs patches from
> > 2.6.29-rc8 applied to it (x86, 64bit).
> 
> A fix for this has entered mainline:
> 
> commit 363911d027d1de1c6df79eb3f487f5476b9619f4
> Author: Phillip Lougher <phillip@lougher.demon.co.uk>
> Date:   Thu Mar 12 03:23:48 2009 +0000
> 
>     Squashfs: Valid filesystems are flagged as bad by the corrupted
> fs patch
> 
> Gr{oetje,eeting}s,
> 
>                                                                   Geert
