Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZJEPHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZJEPHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZJEPHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:07:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbZJEPHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:07:12 -0400
Message-ID: <4ACA0C51.6030809@redhat.com>
Date: Mon, 05 Oct 2009 11:10:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes v2 0/5] tracing/kprobes, 	perf: perf probe
 support take 2
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <y0mocolj3ht.fsf@fche.csb>
In-Reply-To: <y0mocolj3ht.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Masami Hiramatsu<mhiramat@redhat.com>  writes:
>
>> [...]
>> These patches introduce 'perf probe' command and update kprobe-tracer. [...]
>> Usage
>> -----
>>   perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
>> [...]
>>      -k, --vmlinux<file>   vmlinux/module pathname
>>      -r, --release<rel>    kernel release
>> [...]
>
> Can you outline a reason for the -r flag?  We use it in systemtap for
> cross-compiling purposes, but I didn't think perf was interested in that.

Indeed, thanks!
I just forgot to remove -r option from the code of c2kpe.c :(

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

