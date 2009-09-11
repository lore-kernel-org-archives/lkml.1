Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZIKPiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZIKPiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZIKPiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:38:12 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52996 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZIKPiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YxSg3ut2ikAuVGyJ7y3Xe1WDPHqd+hIfSM7Z5Tm0uYiLS+ZrA7lpl3Unux5XHvVXgF
         IELTfkPoWr28S8TtR41VcgNC78ZMLancvqqv07rcfFLlZdW4S6UOuWNXF1b5DlnJa5wU
         0snHtNqt9NDooOqrjQEi/7MYDevgijrvCPDX4=
Message-ID: <4AAA6EE2.8000807@gmail.com>
Date: Fri, 11 Sep 2009 18:38:10 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph tracer
References: <20090911135452.866274568@goodmis.org> <20090911135626.824079836@goodmis.org> <20090911145521.GA6119@nowhere> <1252681916.18996.697.camel@gandalf.stny.rr.com> <20090911151811.GB6119@nowhere>
In-Reply-To: <20090911151811.GB6119@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-09-11 18:18, Frederic Weisbecker wrote:
> On Fri, Sep 11, 2009 at 11:11:56AM -0400, Steven Rostedt wrote:
>   
>> On Fri, 2009-09-11 at 16:55 +0200, Frederic Weisbecker wrote:
>>
>>     
>>> Oh, BTW, what would you think about addding the current->lock_depth
>>> in the latency format? That may help debug the bkl...
>>>       
>> Hmm, that would require adding another field for all traces. I don't
>> want to increase the size of an entry unneeded. BTW, this is for all
>> entries (even events).
>>     
>
>
> Right...
>
>  
>   
>> Ug! I just noticed that tgid was added to struct trace_entry, with the
>> only user as the user stack entry. This should be in the user stack
>> field not something that goes into every event!
>>
>> I guess I need to fix that too.
>>     

Indeed tgid should be part of struct userstack_entry, and set in
ftrace_trace_userstack.
Do you want to me to write up a patch for that, or have you already
fixed it?

Best regards,
--Edwin
