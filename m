Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXLRUIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXLRUIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXLRUIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:08:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:41011 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbXLRUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:08:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DKcVFpoirmGLyqtO90p3XFuWXDXzwuxGN53Q42WLqzRzJ7++Tv5Gt9f1flH59dV7cqqCU2sBFCbKzwu8/ocVTml1t0uE/Jz0TVU5HXxhWXtVgkX2nRrS2CX3ENjGKesE3znMHrM/8AQ4UUVKRoQMeLfUR1151ZgPAfflS8EoJPc=
Message-ID: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com>
Date: Tue, 18 Dec 2007 22:08:12 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: linux-mips@ftp.linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: [MIPS] Build an embedded initramfs into mips kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to build a basic initramfs image into the kernel, using
the CONFIG_INITRAMFS_SOURCE. The required result is a single image
loaded into a target containing usermode application (busybox).

I use cross compile mipsel-unknown-linux-uclibc in order to build the
kernel and the initramfs's usermode.

The cpio image is created using cpio -o -H newc command.

The same configuration works with i586-pc-linux-uclibc cross compile.

printk at init/main.c::run_init_process() shows that the
kernel_execve() returns -2 (ENOENT) for /init and -14 (EFAULT) for
/*/init.

Looking at the initramfs /init is available and executable.

Any reason why I get ENOENT?
Any special procedure should be performed for mips arch?

Best Regards,
Alon Bar-Lev.
