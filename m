Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZGKFy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZGKFy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 01:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZGKFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 01:54:52 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35893 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZGKFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 01:54:51 -0400
Date: Sat, 11 Jul 2009 11:24:43 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] ksym_tracer: various fixes
Message-ID: <20090711055443.GA6666@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4A52E291.1020408@cn.fujitsu.com> <20090707231835.GA7514@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707231835.GA7514@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 01:18:37AM +0200, Frederic Weisbecker wrote:
> On Tue, Jul 07, 2009 at 01:52:17PM +0800, Li Zefan wrote:
> > Here are some fixes for ksym_tracer.
> > 
> > [PATCH 1/8] ksym_tracer: Extract trace entry from struct trace_ksym
> > [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
> > [PATCH 3/8] ksym_tracer: Fix validation of access type
> > [PATCH 4/8] ksym_tracer: Fix validation of length of access type
> > [PATCH 5/8] ksym_tracer: NIL-terminate user input filter
> > [PATCH 6/8] ksym_tracer: Report error when failed to re-register hbp
> > [PATCH 7/8] ksym_tracer: Fix memory leak
> > [PATCH 8/8] ksym_tracer: Fix the output of stat tracing
> > ---
> >  kernel/trace/trace_ksym.c |  161 ++++++++++++++++++++++-----------------------
> >  1 files changed, 78 insertions(+), 83 deletions(-)
> > 
> 
> For the whole series:
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Thanks a lot!
> 
> Prasad, any objection?
>

Hi,
	Sorry for the delayed response (just back from a week-long
vacation)..the patches do a fine-job of fixing the issues that escaped
attention during development.

Thanks for the patchset!

-- K.Prasad

