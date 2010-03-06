Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0CFJDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 04:03:55 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:36499 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0CFJDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 04:03:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19346.6765.457769.167118@pilspetsen.it.uu.se>
Date: Sat, 6 Mar 2010 10:03:41 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: dave b <db.pub.mail@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
In-Reply-To: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dave b writes:
 > Hi have now successfully built a 2.6.33 kernel on a linkstation pro
 > v2. This is an arm device. It is currently running debian  lenny
 > armel.
 > 
 > 
 > I compiled  (make) zImage, then did a make modules which failed on the
 > first two rounds of compiling the modules -
 > 
 > "fs/afs/super.c: In function ‘afs_test_super’:
 > fs/afs/super.c:278: internal compiler error: Segmentation fault
 > Please submit a full bug report,
 > with preprocessed source if appropriate.
 > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions."
 > This was the error encountered on the attempt at compiling the
 > modules.
 > 
 > "crypto/gcm.c: In function ‘crypto_gcm_setauthsize’:
 > crypto/gcm.c:152: internal compiler error: Segmentation fault
 > Please submit a full bug report,
 > with preprocessed source if appropriate.
 > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions.
 > make[1]: *** [crypto/gcm.o] Error 1"
 > This was the error the on the second attempt at compiling the modules.
 > 
 > The 3rd attempt at building the modules was successful...
 > 
 > The device boots and runs fine with this kernel and modules appear to work.
 > [root@nas ~]# uname -a
 > Linux nas 2.6.33 #1 Fri Mar 5 23:54:51 EST 2010 armv5tel GNU/Linux
 > 
 > 
 > *SO* is this a gcc bug or is it related to the changes to the build
 > process on arm?
 > 
 > 
 > 
 > gcc -v
 > Using built-in specs.
 > Target: arm-linux-gnueabi
 > Configured with: ../src/configure -v --with-pkgversion='Debian
 > 4.3.2-1.1' --with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs
 > --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
 > --enable-shared --with-system-zlib --libexecdir=/usr/lib
 > --without-included-gettext --enable-threads=posix --enable-nls
 > --with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3
 > --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc
 > --enable-mpfr --disable-libssp --disable-sjlj-exceptions
 > --enable-checking=release --build=arm-linux-gnueabi
 > --host=arm-linux-gnueabi --target=arm-linux-gnueabi
 > Thread model: posix
 > gcc version 4.3.2 (Debian 4.3.2-1.1)

GCC bug. Report it to Debian, just like it asked you to.

In theory it could be flaky hardware or a kernel/CPU combination
with cache coherency issues, but in those cases I'd have expected
many more failures.

The ARM kernel mailing list is linux-arm-kernel@lists.infradead.org.
