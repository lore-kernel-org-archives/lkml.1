Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZE1VYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZE1VYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZE1VYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:24:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbZE1VYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:24:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/12 v2] ptrace: mv task_struct->ptrace_message
	ptrace_ctx->message
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 13:41:00 +0200 <20090528114100.GA18744@redhat.com>
References: <20090528113601.GA18725@redhat.com>
	<20090528114100.GA18744@redhat.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20090528212418.2F605FC2BD@magilla.sf.frob.com>
Date: Thu, 28 May 2009 14:24:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps it is better to optimize out "mask != 0" check in ptrace_event().
> This special !mask case is only needed for _report_clone(), we can use
> mask == PT_PTRACED instead.

Sure, that is fine.  But note it should always have been compiled away
before anyway, since it's inline and constant in every caller.


Thanks,
Roland
