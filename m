Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbXKGVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbXKGVMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXKGVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:12:12 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56996 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbXKGVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:12:10 -0500
Message-ID: <47322340.702@linux.vnet.ibm.com>
Date: Thu, 08 Nov 2007 02:12:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       k.shutemov@gmail.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 make header check fails
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with error

  CHECK   include/asm-generic/siginfo.h
  CHECK   include/asm-generic/resource.h
  CHECK   include/asm-generic/statfs.h
  CHECK   include/asm-generic/signal.h
  CHECK   include/asm-generic/poll.h
  CHECK   include/asm-generic/mman.h
  CHECK   include/asm-generic/ioctl.h
  CHECK   include/asm-generic/fcntl.h
  CHECK   include/asm-generic/errno.h
  CHECK   include/asm-generic/errno-base.h
  CHECK   include/asm/cputable.h
  CHECK   include/asm/byteorder.h
  CHECK   include/asm/bootx.h
  CHECK   include/asm/auxvec.h
  CHECK   include/asm/asm-compat.h
  CHECK   include/asm/a.out.h
  CHECK   include/asm/ucontext.h
  CHECK   include/asm/ps3fb.h
  CHECK   include/asm/linkage.h
  CHECK   include/asm/elf.h
/home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/elf.h requires asm/page.h, which does not exist in exported headers
make[3]: *** [/home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/.check.elf.h] Error 1
make[2]: *** [asm-powerpc] Error 2
make[1]: *** [headers_check] Error 2
make: *** [vmlinux] Error 2


The patch unexport-asm-pageh.patch might be causing the failure.
This one was discussed on http://lkml.org/lkml/2007/1/4/336
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
