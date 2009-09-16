Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZIPIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZIPIK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZIPIK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:10:26 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59865 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbZIPIKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:10:24 -0400
Message-ID: <4AB09D17.7040802@bk.jp.nec.com>
Date: Wed, 16 Sep 2009 17:08:55 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 0/2] tracing: Tracing integration - dynamic ftrace for
 SystemTap
References: <4AAF6724.9080201@bk.jp.nec.com>	 <1253009731.5506.39.camel@laptop>  <1253009974.5506.41.camel@laptop>	 <1253021324.20020.88.camel@gandalf.stny.rr.com> <1253021816.5506.78.camel@laptop>
In-Reply-To: <1253021816.5506.78.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-09-15 at 09:28 -0400, Steven Rostedt wrote:
>> On Tue, 2009-09-15 at 12:19 +0200, Peter Zijlstra wrote:
>>> On Tue, 2009-09-15 at 12:15 +0200, Peter Zijlstra wrote:
>>>> On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
>>>>> The patches doesn't contain the performance counters integration,
>>>>> since it is still in development. I think following implementations are
>>>>> needed:
>>>>> - add new type to perf_id (like PERF_TYPE_FTRACE)
>>>>> - add event ids to struct dyn_ftrace
>>>>> - add interfaces to reference event ids by user (via debugfs?)
>>>>> - add probe function to count ftrace events (call do_perf_swcounter_event)
>>>> That's long since been done,.. 
>>> Or are you talking about the mcount thing? Simply expose the mcount hook
>>> as a regular tracepoint and perf can already use it.
>>>
> 
>> I'm not sure what you mean by exposing the mcount hook as a tracepoint.
>> Or you mean make it a special file in debug/tracing/events/ that lets
>> you enable it as a profile trace?
> 
> Either make it a single tracepoint on which you can apply filters or
> make it generate a tracepoint per mcount site, I don't really mind ;-)
> 
> If kprobes can live in the same space, then surely the function tracer
> can too ;-)

Thank you for your comments.

I understood that I need to make the mechanism to dynamically add tracepoints using
a mcount hook. I'll try to make it.

Thanks,
Atsushi
