Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYJCUKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYJCUKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYJCUKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:10:10 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:49118 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbYJCUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:10:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEAKMS5khMQWq+/2dsb2JhbACBcbpqgWg
Date: Fri, 3 Oct 2008 16:10:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: sparc64: Optimized immediate value implementation build error
Message-ID: <20081003201007.GA16025@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:01:14 up 121 days, 41 min,  5 users,  load average: 0.21,
	0.37, 0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I ran a cross-compiler on the -lttng tree
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git

to build the sparc64 arch, and ran across this build error :

/home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h: In function `do_fork':
/home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: asm operand 1 probably doesn't match constraints
/home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: error: impossible constraint in `asm'
/home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: 'value' might be used uninitialized in this function
make[2]: *** [kernel/fork.o] Error 1

I think it's caused by :
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=c76bfa90a6eb02651368a152b3646aa672d9e625

Any idea what's wrong with the inline asm ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
