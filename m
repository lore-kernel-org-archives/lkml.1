Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXBENYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXBENYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbXBENYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:24:16 -0500
Received: from mcr-smtp-001.bulldogdsl.com ([212.158.248.7]:3447 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932368AbXBENYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:24:15 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: 2.6.20 doesn't compile with gcc-3.2.2
User-Agent: KMail/1.9.5
References: <200702051531.20326.a1426z@gawab.com>
In-Reply-To: <200702051531.20326.a1426z@gawab.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1934
Date: Mon, 5 Feb 2007 13:24:11 +0000
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702051324.11866.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 12:31, you wrote:
> Doing the following results in an incomplete vmlinuz:
>
> # make mrproper
> # make allnoconfig
> # make bzlilo
>
> objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated
> make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
> make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
> make: *** [bzlilo] Error 2
>
> # gcc -v
> Reading specs from /usr/lib/gcc-lib/i586-mandrake-linux-gnu/3.2.2/specs
> Configured with: ../configure --prefix=/usr --libdir=/usr/lib
> --with-slibdir=/lib --mandir=/usr/share/man --infodir=/usr/share/info
> --enable-shared --enable-threads=posix --disable-checking
> --enable-long-long --enable-__cxa_atexit
> --enable-languages=c,c++,ada,f77,objc,java
> --host=i586-mandrake-linux-gnu --with-system-zlib
> Thread model: posix
> gcc version 3.2.2 (Mandrake Linux 9.1 3.2.2-3mdk)
>
>
> Is gcc-4.0.1 now the minimum required to compile the kernel?

A patch went in to remove support for GCC 3.1, but as far as I know, 3.2 
should be a supported compiler.

At any rate, this might be a binutils issue. What version of binutils are you 
using?

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
