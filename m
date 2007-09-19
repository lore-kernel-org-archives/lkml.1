Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXISJ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXISJ3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbXISJ3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:29:07 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2862 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbXISJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:29:05 -0400
Date: Wed, 19 Sep 2007 10:28:48 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc6-mm1 -- powerpc link failure
Message-ID: <20070919092848.GG973@shadowen.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing this strange link error from a PowerMac G5 (powerpc):

  [...]
    KSYM    .tmp_kallsyms2.S
    AS      .tmp_kallsyms2.o
    LD      vmlinux.o
  ld: dynreloc miscount for fs/built-in.o, section .opd
  ld: can not edit opd Bad value
  make: *** [vmlinux.o] Error 1

Compiler version below.

root@elm3b19:~# gcc -v
Using built-in specs.
Target: powerpc-linux-gnu
Configured with: ../src/configure -v
--enable-languages=c,c++,java,f95,objc,ada,treelang --prefix=/usr
--enable-shared --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --enable-nls
--program-suffix=-4.0 --enable-__cxa_atexit --enable-clocale=gnu
--enable-libstdcxx-debug --enable-java-awt=gtk-default
--enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-4.0-1.4.2.0/jre
--enable-mpfr --disable-softfloat
--enable-targets=powerpc-linux,powerpc64-linux --with-cpu=default32
--disable-werror --enable-checking=release powerpc-linux-gnu
Thread model: posix
gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)

-apw
