Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbYCaLTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbYCaLTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYCaLTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:19:25 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56672 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYCaLTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:19:24 -0400
Message-ID: <47F0C8B6.7020808@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2008 16:49:18 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUILD_FAILURE] linux-next: Tree for March 31 build fails on fs/novfs
 sys_flistxattr()
References: <20080331181118.7964d4a9.sfr@canb.auug.org.au>
In-Reply-To: <20080331181118.7964d4a9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The next-20080331 allyesconfig, build fails on x86_64 machine

fs/novfs/built-in.o: In function `sys_flistxattr':
/root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4658: multiple definition of `sys_flistxattr'
fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:457: first defined here
ld: Warning: size of symbol `sys_flistxattr' changed from 112 in fs/xattr.o to 75 in fs/novfs/built-in.o
fs/novfs/built-in.o: In function `sys_fsetxattr':
/root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4672: multiple definition of `sys_fsetxattr'
fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:295: first defined here
ld: Warning: size of symbol `sys_fsetxattr' changed from 164 in fs/xattr.o to 97 in fs/novfs/built-in.o
fs/novfs/built-in.o: In function `sys_fgetxattr':
/root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4645: multiple definition of `sys_fgetxattr'
fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:384: first defined here
ld: Warning: size of symbol `sys_fgetxattr' changed from 128 in fs/xattr.o to 91 in fs/novfs/built-in.o
make[1]: *** [fs/built-in.o] Error 1
make: *** [fs] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
