Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZJTOic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZJTOic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZJTOib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:38:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZJTOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:38:30 -0400
Message-ID: <4ADDCB56.60700@redhat.com>
Date: Tue, 20 Oct 2009 10:38:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
 probe and kprobe-tracer bugfixes
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <4ADCC348.2020800@redhat.com> <20091020065055.GL8550@elte.hu>
In-Reply-To: <20091020065055.GL8550@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> The point is to prefer intuitive, non-mechanic, fundamentally human
>>> expressions of information above mechanic ones (absolute line numbers,
>>> addresses, ways of probing, etc.) - and to have a rich variety of them.
>>>
>>> String based pattern matching and intuitive syntax that reuses existing
>>> paradigms of arithmetics and pattern-matching is good - limited syntax
>>> and extra, arbitrary syntactic hoops to jump through is bad.
>>>
>>> If we provide all that, people will start using this stuff - and i'd
>>> only like to merge this upstream once it's clear that people like me
>>> will (be able to) use this facility for ad-hoc probe insertion.
>>>
>>> In other words: this facility has to 'live within' our source code and
>>> has to be able to interact with it on a very broad basis - for it to be
>>> maximally useful for everyday development.
>>
>> Hmm, so you mean perf-probe should work with source-code? Without 
>> source code (but with debuginfo), maybe we can't use string matching, 
>> is that OK?
> 
> Well most forms of debuginfo embedd the full source code in the 
> debuginfo, right? If it's not there (or we dont know where it is) then 
> we cannot use it, obviously.

Um, actually debuginfo doesn't have the full source code, but has
the source file path. So, only if there are source files,
we can use string-based matching. Even if there are no source files,
that means users can't change their kernel:-). So we don't care
about kernel-version dependency.

> But we obviously want the whole 'perf probe' workflow to primarily 
> operate on source code - we are humans.

Sure :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

