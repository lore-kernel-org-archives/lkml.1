Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZLBNwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZLBNwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZLBNwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:52:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZLBNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:52:10 -0500
Subject: Re: [tip:perf/core] tracing: Add DEFINE_EVENT(),
 DEFINE_SINGLE_EVENT() support to docbook
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
References: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
	 <tip-3a9089fd78367e2c6c815129030b790a0f5c2715@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 08:52:14 -0500
Message-Id: <1259761934.12870.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 10:42 +0000, tip-bot for Jason Baron wrote:
> Commit-ID:  3a9089fd78367e2c6c815129030b790a0f5c2715
> Gitweb:     http://git.kernel.org/tip/3a9089fd78367e2c6c815129030b790a0f5c2715
> Author:     Jason Baron <jbaron@redhat.com>
> AuthorDate: Tue, 1 Dec 2009 12:18:49 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 2 Dec 2009 09:57:37 +0100
> 
> tracing: Add DEFINE_EVENT(), DEFINE_SINGLE_EVENT() support to docbook

Ug, I need more sleep, because I never noticed the "SINGLE" when I acked
this :-p

I thought the DEFINE_SINGLE_EVENT was still under discussion because it
is a confusing name. I suggested to call it exactly what is was.

 DECLARE_CLASS_AND_DEFINE_EVENT()

-- Steve

> 
> The introduction of the new 'DECLARE_EVENT_CLASS()' obviates the
> need for the 'TRACE_EVENT()' macro in some cases. Thus, docbook
> style comments that used to live with 'TRACE_EVENT()' are now
> moved to 'DEFINE_EVENT()'. Thus, we need to make the docbook
> system understand the new 'DEFINE_EVENT()' macro. In addition
> I've tried to futureproof the patch, by also adding support for
> 'DEFINE_SINGLE_EVENT()', since there has been discussion about
> renaming: TRACE_EVENT() -> DEFINE_SINGLE_EVENT().
> 
> Without this patch the tracepoint docbook fails to build.
> 
> I've verified that this patch correctly builds the tracepoint
> docbook which currently covers signals, and irqs.
> 
> Changes in v2:
>  - properly indent perl 'if' statements
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> LKML-Reference: <200912011718.nB1HIn7t011371@int-mx04.intmail.prod.int.phx2.redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>


