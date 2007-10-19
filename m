Return-Path: <linux-kernel-owner+w=401wt.eu-S936378AbXJSUte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936378AbXJSUte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXJSUtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:49:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:37284 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbXJSUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=fYUmgryMswSjtCj3nx57G8f7vfUPzGeyFPubT8BOy0f6hlVIbabOEj8YgRWmAJ2gjDqjhvidLNks7S19TIlrO0wRxsze6EkTUia0Uc2JMnhCIlGbcsm/IL4cAMYlSQPed7UZAQQX0IVJFUBCcitJKflb6rukC3Zyjj6airrk0uo=
Message-ID: <4719174A.7020004@googlemail.com>
Date: Fri, 19 Oct 2007 22:44:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: some kernel headers broken in current git ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

usually I'll wait for rc1 and test compile external module to see which are broken and what need fixing
but while I need virtualbox for some tests I test compile it on current git and it failed badly.

Maybe something is missing from x86 merge ?

Here is what I get :

...

/linux/memobj-r0drv-linux.c
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic_32.h:265,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock_32.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/spinlock.h:87,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:53,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:27: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:34: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:41: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:48: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:55: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: (Each undeclared identifier is reported only once
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: for each function it appears in.)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:59: warning: implicit declaration of function 'atomic64_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:62: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:66: warning: implicit declaration of function 'atomic64_sub'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:69: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:73: warning: implicit declaration of function 'atomic64_sub_and_test'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:76: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:83: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:90: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:94: warning: implicit declaration of function 'atomic64_add_negative'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:97: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:101: warning: implicit declaration of function 'atomic64_add_return'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:104: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:108: warning: implicit declaration of function 'atomic64_sub_return'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:111: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:118: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:125: error: expected ')' before '*' token
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:269: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'populated_zone':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:602: error: 'struct zone' has no member named 'present_pages'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_normal':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:650: error: 'struct zone' has no member named 'zone_pgdat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_dma':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:665: error: 'struct zone' has no member named 'zone_pgdat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:6:25: error: mach_mpspec.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:8: error: 'MAX_MP_BUSSES' undeclared here (not in a function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:22: error: 'MAX_IRQ_SOURCES' undeclared here (not in a function)
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic_32.h:265,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock_32.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/spinlock.h:87,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:53,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:27: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:34: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:41: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:48: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:55: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: (Each undeclared identifier is reported only once
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: for each function it appears in.)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:59: warning: implicit declaration of function 'atomic64_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:62: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:66: warning: implicit declaration of function 'atomic64_sub'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:69: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:73: warning: implicit declaration of function 'atomic64_sub_and_test'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:76: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:83: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:90: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:94: warning: implicit declaration of function 'atomic64_add_negative'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:97: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:101: warning: implicit declaration of function 'atomic64_add_return'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:152:26: error: mach_apicdef.h: No such file or directory
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:104: error: expected declaration specifiers or '...' before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h: In function 'hard_smp_processor_id':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:156: warning: implicit declaration of function 'GET_APIC_ID'/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_return':

/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:108: warning: implicit declaration of function 'atomic64_sub_return'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:111: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:118: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:125: error: expected ')' before '*' token
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/timer.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:8,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h: In function 'ktime_set':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h:84: warning: comparison is always false due to limited range of data type
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:269: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic_32.h:265,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/atomic.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock_32.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/spinlock.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/spinlock.h:87,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:53,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:27: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:34: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:41: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:48: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:55: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: (Each undeclared identifier is reported only once
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: for each function it appears in.)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:57: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:59: warning: implicit declaration of function 'atomic64_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:62: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:64: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:66: warning: implicit declaration of function 'atomic64_sub'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:69: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:71: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:73: warning: implicit declaration of function 'atomic64_sub_and_test'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:76: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:83: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:90: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: 'v' undeclared (first use in this function)In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: At top level:

/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:92: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:94: warning: implicit declaration of function 'atomic64_add_negative'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:97: error: expected declaration specifiers or '...' before 'atomic_long_t'/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: In function 'cancel_delayed_work':

/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:165: error: 'struct work_struct' has no member named 'data'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:99: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:101: warning: implicit declaration of function 'atomic64_add_return'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:104: error: expected declaration specifiers or '...' before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: In function 'atomic_long_sub_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'atomic64_t' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: 'v' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:106: error: expected expression before ')' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:108: warning: implicit declaration of function 'atomic64_sub_return'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:111: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:118: error: expected ')' before '*' token
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm-generic/atomic.h:125: error: expected ')' before '*' token
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'populated_zone':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:602: error: 'struct zone' has no member named 'present_pages'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_normal':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:650: error: 'struct zone' has no member named 'zone_pgdat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_dma':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:665: error: 'struct zone' has no member named 'zone_pgdat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:6:25: error: mach_mpspec.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:8: error: 'MAX_MP_BUSSES' undeclared here (not in a function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:22: error: 'MAX_IRQ_SOURCES' undeclared here (not in a function)
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:152:26: error: mach_apicdef.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h: In function 'hard_smp_processor_id':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:156: warning: implicit declaration of function 'GET_APIC_ID'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:269: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/module.h:18,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:56,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:10: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:22: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:29: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:36: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:44: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:63: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:82: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:101: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:121: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:145: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: invalid lvalue in asm output 1
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: memory input 3 is not directly addressable
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/timer.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:8,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h: In function 'ktime_set':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h:84: warning: comparison is always false due to limited range of data type
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'populated_zone':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:602: error: 'struct zone' has no member named 'present_pages'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_normal':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:650: error: 'struct zone' has no member named 'zone_pgdat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h: In function 'is_dma':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:665: error: 'struct zone' has no member named 'zone_pgdat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:6:25: error: mach_mpspec.h: No such file or directory
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: In function 'cancel_delayed_work':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:165: error: 'struct work_struct' has no member named 'data'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:15,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:8: error: 'MAX_MP_BUSSES' undeclared here (not in a function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/mpspec_32.h:22: error: 'MAX_IRQ_SOURCES' undeclared here (not in a function)
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:152:26: error: mach_apicdef.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/smp.h:19,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/topology.h:33,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mmzone.h:691,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/gfp.h:4,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h: In function 'hard_smp_processor_id':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/smp_32.h:156: warning: implicit declaration of function 'GET_APIC_ID'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/module.h:18,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:56,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:10: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:22: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:29: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:36: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:44: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:63: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:82: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:101: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:121: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:145: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: invalid lvalue in asm output 1
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: memory input 3 is not directly addressable
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/timer.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:8,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h: In function 'ktime_set':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/ktime.h:84: warning: comparison is always false due to limited range of data type
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:11,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h: In function 'cancel_delayed_work':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/workqueue.h:165: error: 'struct work_struct' has no member named 'data'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slab.h:118,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:54,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/slub_def.h:25: error: expected specifier-qualifier-list before 'atomic_long_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'mm_counter_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:183: error: expected specifier-qualifier-list before 'mm_counter_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/module.h:18,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:56,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:10: error: expected specifier-qualifier-list before 'atomic_long_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:22: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:20: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:29: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:27: error: memory input 1 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:36: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:34: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:44: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:42: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_sub_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:63: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:61: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_dec_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:82: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:80: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_inc_and_test':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:101: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:99: error: memory input 2 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_negative':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:121: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: invalid lvalue in asm output 0
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:119: error: memory input 3 is not directly addressable
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h: In function 'local_add_return':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:145: error: 'local_t' has no member named 'a'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: invalid lvalue in asm output 1
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/local_32.h:143: error: memory input 3 is not directly addressable
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'mm_counter_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:183: error: expected specifier-qualifier-list before 'mm_counter_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:518,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:122: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'global_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: warning: implicit declaration of function 'atomic_long_read'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:144: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zap_zone_vm_stats':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:518,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:122: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'global_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: warning: implicit declaration of function 'atomic_long_read'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:144: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zap_zone_vm_stats':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:14,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:24: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'mm_counter_t'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm_types.h:183: error: expected specifier-qualifier-list before 'mm_counter_t'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/mm.h:518,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:60,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:122: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state_add':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:127: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:128: error: too many arguments to function 'atomic_long_add'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'global_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: warning: implicit declaration of function 'atomic_long_read'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:133: error: 'vm_stat' undeclared (first use in this function)
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zone_page_state':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:144: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h: In function 'zap_zone_vm_stats':
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/vmstat.h:196: error: 'struct zone' has no member named 'vm_stat'
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:23,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq_32.h:15:25: error: irq_vectors.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/initterm-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:180: error: 'NR_IRQS' undeclared here (not in a function)
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:23,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq_32.h:15:25: error: irq_vectors.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/alloc-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:180: error: 'NR_IRQS' undeclared here (not in a function)
kmk[3]: *** [/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/out/linux.x86/release/obj/src/VBox/Runtime/RuntimeR0Drv/r0drv/linux/initterm-r0drv-linux.o] Error 1
kmk[3]: *** Waiting for unfinished jobs....
kmk[3]: *** [/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/out/linux.x86/release/obj/src/VBox/Runtime/RuntimeR0Drv/r0drv/linux/alloc-r0drv-linux.o] Error 1
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:23,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/irq_32.h:15:25: error: irq_vectors.h: No such file or directory
In file included from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq_32.h:5,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/asm/hardirq.h:2,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/hardirq.h:7,
                 from /lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/interrupt.h:11,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/the-linux-kernel.h:71,
                 from /work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime/r0drv/linux/memobj-r0drv-linux.c:22:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h: At top level:
/lib/modules/2.6.23-g4fa4d23f-dirty/build/include/linux/irq.h:180: error: 'NR_IRQS' undeclared here (not in a function)
kmk[3]: *** [/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/out/linux.x86/release/obj/src/VBox/Runtime/RuntimeR0Drv/r0drv/linux/memobj-r0drv-linux.o] Error 1
kmk[3]: Leaving directory `/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox/Runtime'
kmk[2]: *** [pass_libraries_before] Error 2
kmk[2]: Leaving directory `/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src/VBox'
kmk[1]: *** [pass_libraries_before] Error 2
kmk[1]: Leaving directory `/work/crazy/VBox/stable/virtualbox/src/VirtualBox-1.5.2_OSE/src'
kmk: *** [pass_libraries_before] Error 2

...


Regards,

Gabriel
