Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbZJFWsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbZJFWsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbZJFWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:48:37 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:55876 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbZJFWsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AVH46c9aooPkp7ky6NX9CiWU7732dVXwGXSl7w9Uj9RVUsCzbz9YzAHjH/dcCr5+mn
         xrxrEq1UAnKdE1R6RfEaa0Hpryb4v3705WRSko23JaN8AI3+ikbdOfdwdxSicGIr+qT4
         WOu7GzA1v04Eb5AMrPwIQ2C+4puEoZ96sLEVI=
Date: Wed, 7 Oct 2009 00:47:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091006224755.GC11007@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com> <20091005192609.GB6071@nowhere> <1254787973.13160.195.camel@gandalf.stny.rr.com> <4ACB52F6.7020106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACB52F6.7020106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 10:23:50AM -0400, Masami Hiramatsu wrote:
> OK, so here are syntax ideas
> 
> * current syntax
> <Ftrace>
> - $sp_var
> - %regs
> - @symbol
> <Perf>
> - local_var


This one looks good.
And why not turning @symbol into symbol?
Then it's up to perf probe to find the right
target.

And @ can be used for raw addresses?

