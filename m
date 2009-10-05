Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbZJEVbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbZJEVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZJEVbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbZJEVbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:31:33 -0400
Message-ID: <4ACA6660.7020607@redhat.com>
Date: Mon, 05 Oct 2009 17:34:24 -0400
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere> <4ACA60E9.30404@redhat.com> <20091005212137.GG6071@nowhere>
In-Reply-To: <20091005212137.GG6071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Oct 05, 2009 at 05:11:05PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> Hmm, the problem is that %1, %2, etc. is not very self-explainable.
>>>
>>> May be %arg1, %arg2, etc.. But would that sound confusing since we
>>> have % for registers?
>>
>> As I sent right now, how about %argumentN ? it will not conflict with
>> register names...
>>
>
> There are archs that have %arg0 %arg1, ... as register names?
>
> Well, arg(n) looks shorter but I won't personnally mind if
> we eventually chose %argumentN. It's also clear, self-explainable
> and it won't collide.

Hmm, one idea hits me, how about this? :)
- %register
- %%spvars (%%retval, %%arg0)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

