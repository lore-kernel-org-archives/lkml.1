Return-Path: <linux-kernel-owner+w=401wt.eu-S1763448AbXEPST3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763448AbXEPST3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbXEPSTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:19:12 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2504 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933958AbXEPSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:19:10 -0400
Message-ID: <464B4AF6.5090604@shadowen.org>
Date: Wed, 16 May 2007 19:18:30 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B458C.1030805@zytor.com>
In-Reply-To: <464B458C.1030805@zytor.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mel Gorman wrote:
>> On (16/05/07 08:16), H. Peter Anvin didst pronounce:
>>> Andy Whitcroft wrote:
>>>> Getting this on both x86 and x86_64 boxes, they are the older boxen so
>>>> likely older compilers:
>>> Please give the gcc version number.
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

SOrry, had to wait for the machine to come idle:

elm3b132:~# gcc -v
Reading specs from /usr/lib/gcc-lib/i486-linux/3.3.4/specs
Configured with: ../src/configure -v
--enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr
--mandir=/usr/share/man --infodir=/usr/share/info
--with-gxx-include-dir=/usr/include/c++/3.3 --enable-shared
--with-system-zlib --enable-nls --without-included-gettext
--enable-__cxa_atexit --enable-clocale=gnu --enable-debug
--enable-java-gc=boehm --enable-java-awt=xlib --enable-objc-gc i486-linux
Thread model: posix
gcc version 3.3.4 (Debian 1:3.3.4-3)
elm3b132:~# dpkg -l | grep binutil
ii  binutils       2.14.90.0.7-8  The GNU assembler, linker and binary
utiliti
elm3b132:~#

> 
> ... as well as binutils version number (it appears that your version of
> ld doesn't support the "ASSERT" statement?)
> 
>> ld:arch/i386/boot/setup.ld:47: syntax error
>> make[1]: *** [arch/i386/boot/setup.elf] Error 1
> 
> 	-hpa

-apw
