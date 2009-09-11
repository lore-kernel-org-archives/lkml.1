Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZIKQIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZIKQIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZIKQID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:08:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:57721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZIKQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NfNMJvHpyOIbcjNYeY9FPGkXykZVC/vklL1NQLkPELFyJwSkjpliBg0JG9vfUGD84N
         9mXQ3XMXNavRk0Tsj1U8SQ87rwF5UzyhrjLQ5ROgOQuWMeR/5AZf3WmCcv+9A8muCV6O
         P3GHICfyTyLttNmdOTsnZmQJUF2MafjxDi5XI=
Message-ID: <4AAA75E0.6020604@gmail.com>
Date: Fri, 11 Sep 2009 19:08:00 +0300
From: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph tracer
References: <20090911135452.866274568@goodmis.org>	 <20090911135626.824079836@goodmis.org> <20090911145521.GA6119@nowhere>	 <1252681916.18996.697.camel@gandalf.stny.rr.com>	 <20090911151811.GB6119@nowhere>  <4AAA6EE2.8000807@gmail.com> <1252684229.18996.699.camel@gandalf.stny.rr.com>
In-Reply-To: <1252684229.18996.699.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-11 18:50, Steven Rostedt wrote:
> On Fri, 2009-09-11 at 18:38 +0300, Török Edwin wrote:
>   
>> On 2009-09-11 18:18, Frederic Weisbecker wrote:
>>     
>>> On Fri, Sep 11, 2009 at 11:11:56AM -0400, Steven Rostedt wrote:
>>>       
>>   
>>     
>>>> Ug! I just noticed that tgid was added to struct trace_entry, with the
>>>> only user as the user stack entry. This should be in the user stack
>>>> field not something that goes into every event!
>>>>
>>>> I guess I need to fix that too.
>>>>     
>>>>         
>> Indeed tgid should be part of struct userstack_entry, and set in
>> ftrace_trace_userstack.
>> Do you want to me to write up a patch for that, or have you already
>> fixed it?
>>     
>
> I've just fixed it, thanks!

Ok.

BTW any plans on integrating an in-kernel unwinder like systemtap has?

Even if I build libc with framepointers, a userspace stacktrace on
x86-64 can't go beyond most pthreads routines, like __read_nocancel
(they're written in asm maybe?).

Best regards,
--Edwin
