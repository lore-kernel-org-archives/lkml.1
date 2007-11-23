Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXKWI7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXKWI7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXKWI7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:59:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43349 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753135AbXKWI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:59:25 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-reply-to: <20071122235141.GA7876@c2.user-mode-linux.org> (message from Jeff
	Dike on Thu, 22 Nov 2007 18:51:41 -0500)
Subject: Re: uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu> <20071114173639.GA7899@c2.user-mode-linux.org> <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu> <20071116170630.GA9299@c2.user-mode-linux.org> <E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu> <20071122235141.GA7876@c2.user-mode-linux.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1IvUNW-0000a5-Vg@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 23 Nov 2007 09:59:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 22, 2007 at 07:08:47PM +0100, Miklos Szeredi wrote:
> > Thanks.  My other problem is (probably you are aware) that recent -mm
> > kernels don't compile for UML.
> 
> The patch below fixes the build for rc3-mm1 for me.

Yeah, I got as far as that (sorry about the incomplete report), but
then I got stuck on this:

  CC      arch/um/kernel/asm-offsets.s
In file included from include/asm/arch/atomic.h:2,
                 from include/asm/atomic.h:9,
                 from include/linux/spinlock.h:333,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/arch/atomic_32.h: In function ‘atomic_add_unless’:
include/asm/arch/atomic_32.h:241: error: ‘struct cpuinfo_um’ has no member named ‘x86’
In file included from include/asm/rwsem.h:4,
                 from include/linux/rwsem.h:24,
                 from include/linux/mm_types.h:11,
                 from include/linux/sched.h:60,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/arch/rwsem.h: In function ‘__down_write_trylock’:
include/asm/arch/rwsem.h:165: error: ‘struct cpuinfo_um’ has no member named ‘x86’

Same config I sent previously.

Miklos
