Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbZEGIhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbZEGIhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZEGIg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:36:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZEGIg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:36:59 -0400
Date: Thu, 7 May 2009 10:31:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507083102.GA20125@redhat.com>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507082027.GD12285@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > /* the callers of ptrace_may_access should be fixed */
> >
> > 	int ptrace_may_access(struct task_struct *task, unsigned int mode)
>
> Sigh, NAK, for the reasons explained in the previous mails.

Agreed, but what about security_operations->ptrace_may_access ?

It has the same (bad) name, but returns the error code or 0 on
success.

Oleg.

