Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZEFCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZEFCIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZEFCIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:08:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZEFCIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:08:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
 exit_state instead of ->mm
In-Reply-To: Andrew Morton's message of  Tuesday, 5 May 2009 18:24:44 -0700 <20090505182444.de4e0143.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20090505224722.GA954@redhat.com>
	<20090505164733.54cd4ca4.akpm@linux-foundation.org>
	<20090505235736.GA7526@redhat.com>
	<20090505182444.de4e0143.akpm@linux-foundation.org>
X-Windows: no hardware is safe.
Message-Id: <20090506020617.7D417FC328@magilla.sf.frob.com>
Date: Tue,  5 May 2009 19:06:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I now have:
> 
> #
> # ptrace
> #
> ptrace-remove-pt_dtrace-from-arch-h8300.patch
> ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
> ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
> ptrace-remove-pt_dtrace-from-arch-m32r.patch
> ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
> ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
> ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
> ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
> #
> # utrace
> #
> signals-tracehook_notify_jctl-change.patch
> utrace-core.patch
> utrace-core-kill-exclude_xtrace-logic.patch

I'd swap these three to be after ...

> #
> ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
> ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
> ptrace-do-not-use-task_lock-for-attach.patch
> ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch

... all these.  Some more ptrace patches will come in and can also go after
these ptrace* ones but before the "utrace three".  When we get there we'll
replace those three including utrace with probably two (a revamp of the
tracehook change plus a single refreshed utrace.patch).


Thanks,
Roland
