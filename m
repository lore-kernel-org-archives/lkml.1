Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZJGC4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZJGC4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZJGC4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZJGC4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:56:22 -0400
Message-ID: <4ACC037C.8020502@redhat.com>
Date: Tue, 06 Oct 2009 22:57:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> 	 <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> 	 <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> 	 <4ACA25D5.10703@redhat.com>  <20091005192609.GB6071@nowhere> 	 <1254787973.13160.195.camel@gandalf.stny.rr.com> 	 <4ACB52F6.7020106@redhat.com> <1254874534.1696.43.camel@gandalf.stny.rr.com>
In-Reply-To: <1254874534.1696.43.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2009-10-06 at 10:23 -0400, Masami Hiramatsu wrote:
>> Steven Rostedt wrote:
>>>
>>
>> OK, so here are syntax ideas
>>
>> * current syntax
>> <Ftrace>
>> - $sp_var
>> - %regs
>> - @symbol
>> <Perf>
>> - local_var
>>
>> * $local syntax
>> <Ftrace>
>> - sp_var
>> - %regs
>> - @symbol
>> <Perf>
>> - $local_var
>>
> 
> I'm fine with either of the above. I don't like either of the below.

OK, I'm fine with current syntax. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

