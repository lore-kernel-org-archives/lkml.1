Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZBEOms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZBEOms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZBEOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:42:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZBEOmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:42:24 -0500
Date: Thu, 5 Feb 2009 15:39:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee
	of ptrace_exit()
Message-ID: <20090205143959.GA20953@redhat.com>
References: <20090129042920.GA5111@redhat.com> <20090205012334.9E60FFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205012334.9E60FFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Roland McGrath wrote:
>
> > No functional changes, preparation for the next patch.
> > 
> > Move the "should we release this child" logic into the separate handler,
> > __ptrace_detach().
> 
> My inclination is to use bool in new code for true/false return values,
> but I don't really care.
> 
> Please canonicalize the comment formatting for your new comments.
> 
> The preserved comment no longer makes sense, there is no "dead list" in
> that function.  Make it a coherent comment at the top that explains the
> return value.

OK, I'll send the cleanup patch.

> Given its content, this function now better belongs in ptrace.c, I think.

I don't completely agree... This helper imho has nothing to do with
ptracing, except it does __ptrace_unlink(). But OK, I will move it
if you prefer. In that case we should export task_detached().

Oleg.

