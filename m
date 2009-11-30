Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZK3WB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZK3WB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZK3WB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:01:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZK3WBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:01:55 -0500
Subject: Re: [PATCH] tracing: add DEFINE_EVENT(), DEFINE_SINGLE_EVENT()
 support to docbook
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       mhiramat@redhat.com, wcohen@redhat.com, fweisbec@gmail.com,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <200911302123.nAULNhaC019844@int-mx02.intmail.prod.int.phx2.redhat.com>
References: <200911302123.nAULNhaC019844@int-mx02.intmail.prod.int.phx2.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 30 Nov 2009 17:01:59 -0500
Message-Id: <1259618519.12870.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 16:23 -0500, Jason Baron wrote:
> The introduction of the new 'DECLARE_EVENT_CLASS()' obviates the need for the
> 'TRACE_EVENT()' macro in some cases. Thus, docbook style comments that used
> to live with 'TRACE_EVENT()' are now moved to 'DEFINE_EVENT()'. Thus, we need
> to make the docbook system understand the new 'DEFINE_EVENT()' macro. In
> addition I've tried to futureproof the patch, by also adding support for
> 'DEFINE_SINGLE_EVENT()', since there has been discussion about renaming:
> TRACE_EVENT() -> DEFINE_SINGLE_EVENT().
> 
> Without this patch the tracepoint docbook fails to build.
> 
> I've verified that this patch correctly builds the tracepoint docbook which
> currently covers signals, and irqs.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


