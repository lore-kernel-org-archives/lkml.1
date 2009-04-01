Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbZDAB1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbZDAB1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZDAB05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:26:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZDAB04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:26:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mtk.manpages@gmail.com
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall -V2
In-Reply-To: Michael Kerrisk's message of  Wednesday, 1 April 2009 14:16:46 +1300 <cfd18e0f0903311816p27a7b8c3jd62e563f4c95299e@mail.gmail.com>
References: <20090324102516.459441533@linutronix.de>
	<20090331152610.GC4792@redhat.com>
	<cfd18e0f0903311816p27a7b8c3jd62e563f4c95299e@mail.gmail.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090401012547.3B581FC3AB@magilla.sf.frob.com>
Date: Tue, 31 Mar 2009 18:25:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,

No.  You can get whatever the caller put into the siginfo_t.
Only the si_signo field is set by the kernel.

> With rt_tgsigqueueinfo(), [...]

You still get whatever the caller put into the siginfo_t.


Thanks,
Roland
