Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZEFFIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZEFFIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZEFFH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:07:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbZEFFH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:07:57 -0400
Date: Tue, 5 May 2009 22:03:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, chrisw@sous-sol.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
 exit_state instead of ->mm
Message-Id: <20090505220332.553be936.akpm@linux-foundation.org>
In-Reply-To: <20090506045613.GB26214@redhat.com>
References: <20090505224722.GA954@redhat.com>
	<20090505164733.54cd4ca4.akpm@linux-foundation.org>
	<20090505235736.GA7526@redhat.com>
	<20090505182444.de4e0143.akpm@linux-foundation.org>
	<20090506020617.7D417FC328@magilla.sf.frob.com>
	<20090506045613.GB26214@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 06:56:13 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> > > signals-tracehook_notify_jctl-change.patch
> > > utrace-core.patch
> > > utrace-core-kill-exclude_xtrace-logic.patch
> >
> > I'd swap these three to be after ...
> >
> > > #
> > > ptrace-ptrace_attach-check-pf_kthread-exit_state-instead-of-mm.patch
> > > ptrace-cleanup-check-set-of-pt_ptraced-during-attach.patch
> > > ptrace-do-not-use-task_lock-for-attach.patch
> > > ptrace_get_task_struct-s-tasklist-rcu-make-it-static.patch
> 
> Yes, that was the plan.
> 
> But, to do this, utrace-core-kill-exclude_xtrace-logic.patch should be
> folded into utrace-core.patch. Otherwise, utrace-core.patch alone can't
> be applied after this new series.

ooooh.
