Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZE1AdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZE1AdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755928AbZE1AdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:33:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZE1AdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:33:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 01:59:36 +0200 <20090527235936.GB12216@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
	<20090527230700.11F2DFC2BD@magilla.sf.frob.com>
	<20090527235936.GB12216@redhat.com>
X-Zippy-Says: Now, I think it would be GOOD to buy FIVE or SIX STUDEBAKERS and
    CRUISE for ARTIFICIAL FLAVORING!!
Message-Id: <20090528003256.86E4EFC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 17:32:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is optimization. If exit_code == 0 we do not need to fixup
> ->last_siginfo. Note that we have another "child->exit_code = exit_code"
> below in the slow path.

Ok, I see.

> > It can check for !child->last_siginfo before lock_task_sighand().
> 
> ptrace_stop() always sets ->last_siginfo != NULL.

Oh, right.  It's only job control stops where it's NULL.

> OK, lets do this change later ;)

Agreed.


Thanks,
Roland
