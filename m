Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0CFKZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 05:25:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:14641 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0CFKZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 05:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L43GmsIHkcJbmlfOsLDUAifY8zOlzfa6oSlarbjWE+8YOyKl8PVUl+Evo/2S2+ODPi
         nMThlJ3qD45v55QtKDKypCGNbqvlAEzCM3LamuVwArzh3G2mtDLr4HlFpr/GxdGjL4MY
         xvVIjTVLJiKIt2G/UkyQZerEkxPOayZCzUO7s=
MIME-Version: 1.0
In-Reply-To: <19346.6765.457769.167118@pilspetsen.it.uu.se>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com> 
	<19346.6765.457769.167118@pilspetsen.it.uu.se>
From: dave b <db.pub.mail@gmail.com>
Date: Sat, 6 Mar 2010 21:24:49 +1100
Message-ID: <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had already reported it to debian -
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=572653

I have cc'ed linux-arm-kernel into this email.



On 6 March 2010 20:03, Mikael Pettersson <mikpe@it.uu.se> wrote:
> dave b writes:
>  > Hi have now successfully built a 2.6.33 kernel on a linkstation pro
>  > v2. This is an arm device. It is currently running debianÂ  lenny
>  > armel.
>  >
>  >
>  > I compiledÂ  (make) zImage, then did a make modules which failed on the
>  > first two rounds of compiling the modules -
>  >
>  > "fs/afs/super.c: In function â€˜afs_test_superâ€™:
>  > fs/afs/super.c:278: internal compiler error: Segmentation fault
>  > Please submit a full bug report,
>  > with preprocessed source if appropriate.
>  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions."
>  > This was the error encountered on the attempt at compiling the
>  > modules.
>  >
>  > "crypto/gcm.c: In function â€˜crypto_gcm_setauthsizeâ€™:
>  > crypto/gcm.c:152: internal compiler error: Segmentation fault
>  > Please submit a full bug report,
>  > with preprocessed source if appropriate.
>  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions.
>  > make[1]: *** [crypto/gcm.o] Error 1"
>  > This was the error the on the second attempt at compiling the modules.
>  >
>  > The 3rd attempt at building the modules was successful...
>  >
>  > The device boots and runs fine with this kernel and modules appear to work.
>  > [root@nas ~]# uname -a
>  > Linux nas 2.6.33 #1 Fri Mar 5 23:54:51 EST 2010 armv5tel GNU/Linux
>  >
>  >
>  > *SO* is this a gcc bug or is it related to the changes to the build
>  > process on arm?
>  >
>  >
>  >
>  > gcc -v
>  > Using built-in specs.
>  > Target: arm-linux-gnueabi
>  > Configured with: ../src/configure -v --with-pkgversion='Debian
>  > 4.3.2-1.1' --with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs
>  > --enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
>  > --enable-shared --with-system-zlib --libexecdir=/usr/lib
>  > --without-included-gettext --enable-threads=posix --enable-nls
>  > --with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3
>  > --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc
>  > --enable-mpfr --disable-libssp --disable-sjlj-exceptions
>  > --enable-checking=release --build=arm-linux-gnueabi
>  > --host=arm-linux-gnueabi --target=arm-linux-gnueabi
>  > Thread model: posix
>  > gcc version 4.3.2 (Debian 4.3.2-1.1)
>
> GCC bug. Report it to Debian, just like it asked you to.
>
> In theory it could be flaky hardware or a kernel/CPU combination
> with cache coherency issues, but in those cases I'd have expected
> many more failures.
>
> The ARM kernel mailing list is linux-arm-kernel@lists.infradead.org.
>
