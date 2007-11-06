Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbXKFLsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbXKFLsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXKFLss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:48:48 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:7737 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXKFLsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=DaCmde0F3KV8saShbZ6/fBOu58EETySiC5RHP80+na9U9z9sGCAl2TKDEpVinrB+ia7nZ8iZooHn3Anx6G+pU3Q/V7lsG2ko+vbVkveGTr6Qh6uy8G248MbTrlL+/5BfD4N+UtUpXwkZllprZ9VoHHonrRjAGLp3PxmdQPt/4Kw=
Date: Tue, 6 Nov 2007 19:46:02 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net
Subject: UML defconfig building failed again
Message-ID: <20071106114602.GB7652@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Jeff!

I used today's linus-tree and defconfig to compile uml, but it failed. Error messages are
things like:

In file included from include/asm/processor-generic.h:13,
                 from include/asm/processor.h:77,
                 from include/asm/thread_info.h:11,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/asm/ptrace.h:50: warning: ‘struct user_fxsr_struct’ declared inside parameter list
include/asm/ptrace.h:50: warning: its scope is only this definition or declaration, which is probably not what you want
include/asm/ptrace.h:52: warning: ‘struct user_fxsr_struct’ declared inside parameter list
In file included from include/linux/timer.h:5,
                 from include/linux/sched.h:87,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/ktime.h: In function ‘ktime_set’:
include/linux/ktime.h:84: warning: comparison is always false due to limited range of data type

{snip}

It seems like CONFIG_X86_32 was not set. Any ideas?

Thanks.


