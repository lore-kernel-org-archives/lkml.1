Return-Path: <linux-kernel-owner+w=401wt.eu-S1762941AbZE2UTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762941AbZE2UTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 16:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759858AbZE2UTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 16:19:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758466AbZE2UTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 16:19:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/12 v2] ptrace: introduce task_struct->ptrace_cxt
In-Reply-To: Oleg Nesterov's message of  Friday, 29 May 2009 14:05:15 +0200 <20090529120515.GB19812@redhat.com>
References: <20090528113533.GA18670@redhat.com>
	<20090528213439.C3587FC2BD@magilla.sf.frob.com>
	<20090529120515.GB19812@redhat.com>
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Message-Id: <20090529201856.1F451FC2BD@magilla.sf.frob.com>
Date: Fri, 29 May 2009 13:18:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 5/12 still needs a comment about its assumption that tracehook_init_task()
> > allocated the struct iff appropriate.
> 
> Not sure I understand... Where should I put this comment?

ptrace_init_task, to explain this line:

-	if (unlikely(ptrace)) {
+	if (unlikely(child->ptrace_ctx)) {

> OK, will redo and resend. Perhaps I should send this series to you
> privately? I don't like to flood lkml again, the changes are cosmetic.

:-) Whatever you like.  They will surely be posted at least twice more
before they get merged either way.  The idea that any actual useful patches
might pollute the purity of the lkml stream is amusing.  (Post them twice,
it will nudge up the signal-to-noise ratio. ;-)


Thanks,
Roland
