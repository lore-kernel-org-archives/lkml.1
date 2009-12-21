Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZLUSe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZLUSe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZLUSeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:34:25 -0500
Received: from 28dayslater.mr.itd.umich.edu ([141.211.12.118]:53597 "EHLO
	28dayslater.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbZLUSeZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:34:25 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2009 13:34:24 EST
From: Mike Garrison <mcgarr@umich.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: 2.6.32.2: undefined reference to `__udivdi3'
Date: Mon, 21 Dec 2009 13:22:45 -0500
Message-Id: <61FF0336-4E17-4EE5-9471-01360A6F7D29@umich.edu>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1077)
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same problem as Arvids and Andreas:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `menu_select':
menu.c:(.text+0x139711): undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

Reading specs from /usr/lib/gcc/i686-pc-linux-gnu/3.4.5/specs
Configured with: ./configure --prefix=/usr --enable-shared --enable-languages=c,c++ --enable-threads=posix --with-slibdir=/lib --enable-__cxa_atexit --enable-clocale=gnu
Thread model: posix
gcc version 3.4.5

This is a custom build of Linux based on Linux From Scratch. I've had no issues with 2.6.31.X

--
Mike Garrison