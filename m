Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbXEEQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbXEEQLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbXEEQLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:11:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29895 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbXEEQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:11:45 -0400
Message-ID: <84144f020705050336p5988f21fv9b7cd628c0ef6c87@mail.gmail.com>
Date: Sat, 5 May 2007 13:36:14 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Google-Sender-Auth: 5f6f3bdb96628666
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

Someone broke UML.

$ make ARCH=um defconfig
$ make

[snip]

  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-um
  CC      arch/um/kernel/asm-offsets.s
In file included from include/asm/cpufeature.h:4,
                 from include/asm/arch/system.h:6,
                 from include/asm/system-generic.h:4,
                 from include/asm/system.h:4,
                 from include/linux/spinlock.h:57,
                 from include/linux/capability.h:73,
                 from include/linux/sched.h:46,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/arch/cpufeature.h:13:35: error: asm/required-features.h:
No such file or directory
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
