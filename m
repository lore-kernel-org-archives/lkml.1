Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZEFFBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZEFFBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZEFFBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:01:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZEFFBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:01:31 -0400
Date: Wed, 6 May 2009 06:56:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090506045613.GB26214@redhat.com>
References: <20090505224722.GA954@redhat.com> <20090505164733.54cd4ca4.akpm@linux-foundation.org> <20090505235736.GA7526@redhat.com> <20090505182444.de4e0143.akpm@linux-foundation.org> <20090506020617.7D417FC328@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506020617.7D417FC328@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05, Roland McGrath wrote:
>
> > I now have:
> >
> > #
> > # ptrace
> > #
> > ptrace-remove-pt_dtrace-from-arch-h8300.patch
> > ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
> > ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
> > ptrace-remove-pt_dtrace-from-arch-m32r.patch
> > ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
> > ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
> > ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
> > ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
> > #
> > # utrace
> > #
> > signals-tracehook_notify_jctl-change.patch
> > utrace-core.patch
> > utrace-core-kill-exclude_xtrace-logic.patch
>
> I'd swap these three to be after ...
>
> > #
> > ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
> > ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
> > ptrace-do-not-use-task_lock-for-attach.patch
> > ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch

Yes, that was the plan.

But, to do this, utrace-core-kill-exclude_xtrace-logic.patch should be
folded into utrace-core.patch. Otherwise, utrace-core.patch alone can't
be applied after this new series.

Oleg.

