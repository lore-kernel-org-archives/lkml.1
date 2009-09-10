Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZIJC05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZIJC05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 22:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZIJC04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 22:26:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZIJC04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 22:26:56 -0400
Message-ID: <4AA863A7.5030909@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 10:25:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing: Clean up trace.h
References: <4AA8579B.4020706@cn.fujitsu.com> <1252549061.18996.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1252549061.18996.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2009年09月10日 10:17, Steven Rostedt 写道:
> On Thu, 2009-09-10 at 09:34 +0800, Li Zefan wrote:
>> - remove some dead code
>> - remove @stats from struct tracer
>> - move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
>>   to kernel/trace/trace_events_filter.c
>>
> 
> Actually, Li if you don't mind, I'm going to break this up into separate
> patches. Each of the above "topics" really should be a separate patch.
> It makes bisecting and such nicer if for some strange reason this patch
> became the cause.
> 

Actually it does more than I described:

- indent some lines
- fix a typo in comment
- remove trace_field_cont
- remove tracer_switch_ops
- remove @stats from struct tracer
- move 2 macros to trace_events_filter.c

I'm not sure it worths breaking into several patches, since each of them
is trivial.

But I won't mind if you break this up, or if you want me to do
this.

