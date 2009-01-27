Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZA0Jfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZA0Jfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZA0Jf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:35:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40677 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZA0JfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:35:25 -0500
Date: Tue, 27 Jan 2009 09:35:16 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: New build regressions: 2.6.27-rc2-git2
Message-ID: <20090127093516.GA27545@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From this morning's ARM kautobuild:

magician defconfig:

drivers/built-in.o: In function `debugfs_create_size_t':
led-core.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
kernel/built-in.o:dma-coherent.c:(.text+0x0): first defined here

s3c6400 defconfig:

fs/built-in.o: In function `debugfs_create_size_t':
include/linux/debugfs.h:168: multiple definition of `debugfs_create_size_t'
kernel/built-in.o:include/linux/debugfs.h:168: first defined here
drivers/built-in.o: In function `debugfs_create_size_t':
include/linux/debugfs.h:168: multiple definition of `debugfs_create_size_t'
kernel/built-in.o:include/linux/debugfs.h:168: first defined here

IXP4xx defconfig:

drivers/usb/host/ohci-hcd.o: In function `debugfs_create_size_t':
ohci-hcd.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
drivers/usb/host/ehci-hcd.o:ehci-hcd.c:(.text+0x0): first defined here
drivers/usb/host/uhci-hcd.o: In function `debugfs_create_size_t':
uhci-hcd.c:(.text+0x0): multiple definition of `debugfs_create_size_t'
drivers/usb/host/ehci-hcd.o:ehci-hcd.c:(.text+0x0): first defined here

... repeat for about 80 other ARM defconfigs.  Haven't had time to
investigate.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
