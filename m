Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYDEQWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYDEQWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 12:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYDEQWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 12:22:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:39766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbYDEQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 12:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PgfKir9yWejCP4WF4KoDaKKVIPEDf2iiYI7GABuMEdSfc866E3XQ9S0dPdPPncR5KxHYEEnV5b2DsxYUZrACf3/8o1Iq0YdHs36kLLNfVFEnunJYTM3KskkdzpcruDOmdjN4j4eXUptjPMzOsmWGoy8HgD/NCrATXuIUpWvuP98=
Message-ID: <9e0cf0bf0804050921x46dd7c8dg80dc5b6da024426d@mail.gmail.com>
Date: Sat, 5 Apr 2008 19:21:59 +0300
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: SH4 - Cannot make initramfs work
In-Reply-To: <9e0cf0bf0804020817s2f558479ve9bca8f82981f7bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e0cf0bf0804020817s2f558479ve9bca8f82981f7bb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Can anyone help with this issue?
Maybe some idea of how to debug this further?

Thanks!

On 4/2/08, Alon Bar-Lev <alon.barlev@gmail.com> wrote:
> Hello,
>
>  I am trying to boot 2.6.24 kernel on SH4 eb using embedded initramfs.
>
>  The kernel boots, but when trying to decompress the initramfs image it
>  fails with "crc error",
>  resulting from lib/inflate.c::gunzip:1250.
>
>  Has anyone got this error? The initramfs image is correct. I also
>  dumped the memory of __initramfs_start->__initramfs_start and verified
>  that it matches the initramfs image on usr/initramfs_data.cpio.gz.
>
>  I then noticed that the kernel code at
>  init/initramfs::unpack_to_rootfs:459 supports handling
>  uncompressed archives. So I compiled a kernel with uncompressed archived.
>
>  I also hooked the init/initramfs::do_name:585 functions, and see that
>  "/init' is passed
>  to sys_open, and sys_open returns with -EOENT (-2).
>
>  How can it be? shouldn't rootfs always be available?
>
>  The same attempt on i586, mipsel is working as expected.
>
>  Any ideas?
>  1. Why decompression working for kernel and not for initramfs (crc error).
>  2. Why files cannot be created on rootfs?
>
>  Thank you,
>
> Alon Bar-Lev.
>
