Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZEZUeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZEZUeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbZEZUeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:34:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbZEZUeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:34:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/X] ptrace: introduce the empty "struct
	ptrace_task"
In-Reply-To: Ingo Molnar's message of  Monday, 25 May 2009 05:30:51 +0200 <20090525032426.GA20687@elte.hu>
References: <20090525000001.GA2218@redhat.com>
	<20090525032426.GA20687@elte.hu>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20090526203308.250D2FC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 13:33:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please use 'struct ptrace_context' and '*ptrace_ctx' instead.

I am fine with this name (or any other).  But note in considering your
suggestions that we will shortly have another separate struct with a
similar name.  The first one is the state of a ptrace tracee task (bits
about itself and pointing to its tracer).  The second is the state of a
ptrace tracer (head of its tracees list, locks, etc).

A name like "ptrace_context" could be read as intuitive for either of these
two quite different things.  Perhaps this is true of "ptrace_task" too,
though it seemed to us like it wasn't too unclear, and preferably shorter
than something like "ptrace_tracee_context".


Thanks,
Roland
