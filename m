Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZGGXSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZGGXSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZGGXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:18:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:41428 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZGGXSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iyPkP4quG6S0DIlWBRbG9ZUHNc663U9UySesWxXVAe4Z7nrfh0k+YvU0CvJDey+TnR
         94PiN6vZ5lx/Tjrwtcn25fXqsPHrbwAveVZZeM97nM3gz69fQE5wMvz81sEn65vLYWLR
         yvBlmzkluILP+6Q6WmS0Q0aytZgvkTxaPMa4g=
Date: Wed, 8 Jul 2009 01:18:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] ksym_tracer: various fixes
Message-ID: <20090707231835.GA7514@nowhere>
References: <4A52E291.1020408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:52:17PM +0800, Li Zefan wrote:
> Here are some fixes for ksym_tracer.
> 
> [PATCH 1/8] ksym_tracer: Extract trace entry from struct trace_ksym
> [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
> [PATCH 3/8] ksym_tracer: Fix validation of access type
> [PATCH 4/8] ksym_tracer: Fix validation of length of access type
> [PATCH 5/8] ksym_tracer: NIL-terminate user input filter
> [PATCH 6/8] ksym_tracer: Report error when failed to re-register hbp
> [PATCH 7/8] ksym_tracer: Fix memory leak
> [PATCH 8/8] ksym_tracer: Fix the output of stat tracing
> ---
>  kernel/trace/trace_ksym.c |  161 ++++++++++++++++++++++-----------------------
>  1 files changed, 78 insertions(+), 83 deletions(-)
> 

For the whole series:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks a lot!

Prasad, any objection?



