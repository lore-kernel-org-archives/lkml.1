Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZDDVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZDDVDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZDDVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:02:44 -0400
Received: from www.tglx.de ([62.245.132.106]:54159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZDDVCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:02:44 -0400
Message-Id: <20090404201641.328118982@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 04 Apr 2009 21:00:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [patch 0/3] add rt_tgsigqueueinfo syscall for 2.6.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Andrew,

the following patch set has been discussed and reviewed on LKML for
quite a while and has reached its final state.

It implements sys_rt_tgsigqueueinfo which allows to queue signals to
a particulart thread. It's the counterpart for sys_rt_sigqueueinfo
and complements the sys_kill / sys_tgkill interface pair.

While I think that the ability to target a particular thread is useful
itself the lack of this interface is a serious show stopper for migrating
existing applications from other Unix like OSes which provide this.

The new syscall interface is acked by Ulrich and the implementation has
been reviewed by Oleg and acked by Roland.

Please apply.

Thanks,

	tglx

