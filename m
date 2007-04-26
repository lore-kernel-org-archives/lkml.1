Return-Path: <linux-kernel-owner+w=401wt.eu-S1031273AbXDZPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031273AbXDZPYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031278AbXDZPYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:24:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:20193 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031273AbXDZPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FF3sJWUFVrdwumwKmYk50Xv48T5/bc5g+kHPWOynhqQXVD0T6AORbYVR1dXtyAlERt/zdpwpJH9CC7wFNh7uXRDpouK/blWyTrJXLEC6BROJZYxxS+SuQIUDTeOd+rTmn0/agPYD8gkE5EJk05U/gKI4I0VugBaHqVxEKnGOqhs=
Message-ID: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
Date: Fri, 27 Apr 2007 00:24:32 +0900
From: "l l" <happyarch@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: linux-2.6.21 and __udivid3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How to link libgcc.a with linux-2.6.21?

  LD      .tmp_vmlinux1
kernel/built-in.o: In function `timespec_add_ns':
/usr/src/linux-2.6.21/kernel/timer.c:828: undefined reference to `__udivdi3'
/usr/src/linux-2.6.21/kernel/timer.c:841: undefined reference to `__udivdi3'
/usr/src/linux-2.6.21/kernel/timer.c:1311: undefined reference to `__udivdi3'
make[1]: *** [.tmp_vmlinux1] Error 1
make[1]: Leaving directory `/usr/src/linux-2.6.21'
make: *** [debian/stamp-build-kernel] Error 2

cc -v
Using built-in specs.
Target: i686-pc-linux-gnu
Configured with: ../gcc/configure --prefix=/usr --libexecdir=/usr/lib
--enable-shared --enable-threads=posix --enable-__cxa_atexit
--enable-clocale=gnu --enable-languages=c,c++,treelang
--with-system-zlib --with-gmp --enable-mpfr
--enable-libstdcxx-allocator=mt
Thread model: posix
gcc version 4.3.0 20070420 (experimental)

TIA
