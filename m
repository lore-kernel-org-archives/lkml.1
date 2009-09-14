Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZINCWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZINCWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZINCWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:22:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:44836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZINCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:22:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZbcN993BGWn15fiGi8unh4cxhSoxeXir+oOwk2vADME5Oj5g9CtWqv9dd0OaJet+5r
         CCv10+2tr09Q1wmKCuqDDs2246VxgPS4dkEs9TbvQhH/DurtpR+50oSIQS8KqArzXwxk
         LITLwxtKiqssyCjcsBvyP8pYZ3ZyOMxaJNtqA=
Date: Mon, 14 Sep 2009 04:22:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based event
	tracer update and perf support
Message-ID: <20090914022248.GA14306@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911153609.GA6069@nowhere> <4AAAC5A8.208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAAC5A8.208@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 05:48:24PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>>
>> I've tested the above example and it works very well,
>> so I've applied this set, and the previous pending patches
>> in:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
>> 	tracing/kprobes
>
> I had a bug on that tree when I did Step.1
>
> > (Step.1) Define new events under new group
> >
> > $ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
> >  > /debug/tracing/kprobes_events
> > $ echo r:mygroup/myretprobe do_sys_open rv >> /debug/tracing/kprobes_events
> > $ cat /debug/tracing/kprobes_events
> > p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
> > r:myretprobe do_sys_open+0 rv=rv
>
> It seems that you forget to pull PATCH 7/7 of my previous series.
> And also I've found my probe registration order is buggy.
> I'll fix that.
>
> Thank you,



Sorry :-s 

Applied, thanks.

