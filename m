Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbZJEVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbZJEVCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZJEVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbZJEVCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:02:32 -0400
Message-ID: <4ACA5F9C.7020001@redhat.com>
Date: Mon, 05 Oct 2009 17:05:32 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com> <20091005192609.GB6071@nowhere>
In-Reply-To: <20091005192609.GB6071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>> - @global-symbol
>
>
> We could use global-symbol as is. Shadowing between global
> and local vars could be dealt with scope resolution:
>
> function:var
> file:var
> file:line:var
>
> And throw errors while submitting a shadowed var name, crying until
> the user defines the scope, only if needed of course (if there are
> no shadowing detected, we can submit a naked variable name).

Sure, via perf-probe, global/local symbols will be translated into
@address by debuginfo.
But without debuginfo, we still need @symbol syntax for accessing
global defined symbols.

>> - +|-Offs(ARG)
>
> You mean for arg numbers?
> So we would have +1 for argument 1?

Sorry for confusing you, it is for deref syntax.

> arg(1) looks more easy to remember and to understand, no?

I think arg(N) seems a bit different from other parts.
Perhaps, %argumentN is possible ? :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

