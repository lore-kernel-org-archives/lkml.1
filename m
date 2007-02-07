Return-Path: <linux-kernel-owner+w=401wt.eu-S1161082AbXBGJdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082AbXBGJdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030610AbXBGJdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:33:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030609AbXBGJdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:33:39 -0500
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 doesn't compile with gcc-3.2.2
References: <200702051531.20326.a1426z@gawab.com>
From: Andi Kleen <ak@suse.de>
Date: 07 Feb 2007 11:33:52 +0100
In-Reply-To: <200702051531.20326.a1426z@gawab.com>
Message-ID: <p7364aemf3j.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> writes:

> Doing the following results in an incomplete vmlinuz:
> 
> # make mrproper
> # make allnoconfig
> # make bzlilo
> 
> objcopy: arch/i386/boot/compressed/vmlinux.bin: File truncated

This looks more like some local problem. Are you sure you didn't run out of
disk space or similar?  When you rerun make what error do you see?

> make[2]: *** [arch/i386/boot/compressed/vmlinux.bin] Error 1
> make[1]: *** [arch/i386/boot/compressed/vmlinux] Error 2
> make: *** [bzlilo] Error 2
> 
> # gcc -v
> Reading specs from /usr/lib/gcc-lib/i586-mandrake-linux-gnu/3.2.2/specs
> Configured with: ../configure --prefix=/usr --libdir=/usr/lib 
> --with-slibdir=/lib --mandir=/usr/share/man --infodir=/usr/share/info 
> --enable-shared --enable-threads=posix --disable-checking --enable-long-long 
> --enable-__cxa_atexit --enable-languages=c,c++,ada,f77,objc,java 
> --host=i586-mandrake-linux-gnu --with-system-zlib
> Thread model: posix
> gcc version 3.2.2 (Mandrake Linux 9.1 3.2.2-3mdk)
> 
> 
> Is gcc-4.0.1 now the minimum required to compile the kernel?

3.2 should work. Only 2.xx support was dropped.

-Andi
