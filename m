Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZE2MJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZE2MJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 08:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZE2MJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 08:09:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZE2MJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 08:09:51 -0400
Date: Fri, 29 May 2009 14:05:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/12 v2] ptrace: introduce task_struct->ptrace_cxt
Message-ID: <20090529120515.GB19812@redhat.com>
References: <20090528113533.GA18670@redhat.com> <20090528213439.C3587FC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528213439.C3587FC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Roland McGrath wrote:
>
> 5/12 still needs a comment about its assumption that tracehook_init_task()
> allocated the struct iff appropriate.

Not sure I understand... Where should I put this comment?

> Some log entries (or maybe comments)
> I saw said "->pt_*" though that is not the name of the field in the patch.

Yes, the changelog for 9/12.

> Other than the task_lock/kfree nit in 4/12 it all looks good to me so far.

OK, will redo and resend. Perhaps I should send this series to you
privately? I don't like to flood lkml again, the changes are cosmetic.

Oleg.

