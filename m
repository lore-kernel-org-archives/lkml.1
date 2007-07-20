Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbXGTQ5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbXGTQ5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763013AbXGTQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:56:17 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:63781 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742AbXGTQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:56:15 -0400
Message-ID: <46A0C199.8050401@l4x.org>
Date: Fri, 20 Jul 2007 16:07:21 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070717)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
References: <20070720091707.GA26717@linux-sh.org>
In-Reply-To: <20070720091707.GA26717@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> Paul Mundt (5):
>       sh64: Wire up fallocate() syscall.
>       sh64: Update cayman defconfig.
>       sh64: Fix up PCI section mismatch warnings.
>       sh64: Move entry point code to .text.head.
>       sh64: Flag sh64_get_page() as __init_refok.

Tangential question. Which is the currently recommended cross toolchain
for sh64? With "gcc 3.2 20020529", "binutils 020306 20030206" (some
binary toolchain from ~2 years ago somewhere off the web) I get [1]

   CC      fs/seq_file.o
   CC      fs/xattr.o
fs/xattr.c: In function `vfs_listxattr':
fs/xattr.c:161: unrecognizable insn:
(insn 162 159 114 (set (subreg:DI (reg:SI 181) 0)
         (reg:DI 182)) -1 (nil)
     (nil))
fs/xattr.c:161: Internal compiler error in get_attr_highpart, at 
insn-attrtab.c:6211
Please submit a full bug report,
with preprocessed source if appropriate.
See <URL:http://www.gnu.org/software/gcc/bugs.html> for instructions.
make[2]: *** [fs/xattr.o] Error 1
make[1]: *** [fs] Error 2
make: *** [_all] Error 2

gcc 3.4.x, 4.0.x, 4.1.x don't build for me from source
(target -superh-linux-gnu, binutils 2.15.x or 2.17.x).

Thanks,

Jan

[1] http://l4x.org/k/?d=32100
