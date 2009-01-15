Return-Path: <linux-kernel-owner+w=401wt.eu-S936154AbZAOWyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936154AbZAOWyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935067AbZAOWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:12:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068AbZAOWMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:12:18 -0500
Date: Thu, 15 Jan 2009 23:11:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trailing whitespace in kernel/ptrace.c
Message-ID: <20090115221135.GA10283@elte.hu>
References: <20090115205751.B5F6EFC3DD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115205751.B5F6EFC3DD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> These bug me every time I want to touch ptrace.c, nix them.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  kernel/ptrace.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

btw., here's the checkpatch output from that file:

------------------>

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#26: FILE: ptrace.c:26:
+#include <asm/uaccess.h>

ERROR: trailing whitespace
#51: FILE: ptrace.c:51:
+ $

WARNING: braces {} are not necessary for any arm of this statement
#63: FILE: ptrace.c:63:
+		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
[...]
+		} else {
[...]

CHECK: memory barrier without comment
#157: FILE: ptrace.c:157:
+	smp_rmb();

ERROR: return is not a function, parentheses are not required
#172: FILE: ptrace.c:172:
+	return (!err ? true : false);

WARNING: line over 80 characters
#266: FILE: ptrace.c:266:
+int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)

ERROR: trailing whitespace
#286: FILE: ptrace.c:286:
+^I^Ilen -= retval;^I^I^I$

WARNING: line over 80 characters
#291: FILE: ptrace.c:291:
+int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len)

ERROR: trailing whitespace
#311: FILE: ptrace.c:311:
+^I^Ilen -= retval;^I^I^I$

ERROR: else should follow close brace '}'
#425: FILE: ptrace.c:425:
+	}
+	else

WARNING: line over 80 characters
#455: FILE: ptrace.c:455:
+		ret = put_user(child->ptrace_message, (unsigned long __user *) data);

total: 5 errors, 6 warnings, 1 checks, 741 lines checked

kernel/ptrace.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

