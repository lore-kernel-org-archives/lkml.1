Return-Path: <linux-kernel-owner+w=401wt.eu-S935484AbXGTPQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935484AbXGTPQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934064AbXGTPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:16:10 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:49319 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933859AbXGTPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:16:09 -0400
Date: Sat, 21 Jul 2007 00:15:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jan Dittmer <jdi@l4x.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
Message-ID: <20070720151543.GA28274@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jan Dittmer <jdi@l4x.org>, linux-kernel@vger.kernel.org
References: <20070720091707.GA26717@linux-sh.org> <46A0C199.8050401@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A0C199.8050401@l4x.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 04:07:21PM +0200, Jan Dittmer wrote:
> Paul Mundt wrote:
> >Paul Mundt (5):
> >      sh64: Wire up fallocate() syscall.
> >      sh64: Update cayman defconfig.
> >      sh64: Fix up PCI section mismatch warnings.
> >      sh64: Move entry point code to .text.head.
> >      sh64: Flag sh64_get_page() as __init_refok.
> 
> Tangential question. Which is the currently recommended cross toolchain
> for sh64? With "gcc 3.2 20020529", "binutils 020306 20030206" (some
> binary toolchain from ~2 years ago somewhere off the web) I get [1]
> 
>   CC      fs/seq_file.o
>   CC      fs/xattr.o
> fs/xattr.c: In function `vfs_listxattr':
> fs/xattr.c:161: unrecognizable insn:
> (insn 162 159 114 (set (subreg:DI (reg:SI 181) 0)
>         (reg:DI 182)) -1 (nil)
>     (nil))
> fs/xattr.c:161: Internal compiler error in get_attr_highpart, at 
> insn-attrtab.c:6211
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://www.gnu.org/software/gcc/bugs.html> for instructions.
> make[2]: *** [fs/xattr.o] Error 1
> make[1]: *** [fs] Error 2
> make: *** [_all] Error 2
> 
> gcc 3.4.x, 4.0.x, 4.1.x don't build for me from source
> (target -superh-linux-gnu, binutils 2.15.x or 2.17.x).

I've been using sh64-linux targetted toolchains created from the gentoo
crossdev, which works fine with stock versions. I can send you a tarball
of the toolchain off-list if you like.

Applications are still in a pretty questionable state with recent
compilers, but the kernel does hold up well enough.
