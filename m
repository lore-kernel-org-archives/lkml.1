Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZIWQlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZIWQlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZIWQlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZIWQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:41:00 -0400
Message-ID: <4ABA5004.7050903@redhat.com>
Date: Wed, 23 Sep 2009 09:42:44 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling	updates
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <20090923105252.GA32176@elte.hu>
In-Reply-To: <20090923105252.GA32176@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>> Hi Ingo,
>>
>> Kprobes has been nicely improved lately. The x86 instruction decoder 
>> has been fixed to support cross builds and mmx instruction set, 
>> besides of a lot of various kprobes core fixes.
>>
>> The tracing part has evolved too, we can define human names for 
>> arguments and custom subsystem names for dynamic tracepoints.
>>
>> And also kprobes profiling and raw dynamic tracepoint samples are now 
>> supported through perf. Looks like most of the kernel parts are now in 
>> place for a perf support. Things are going to be focused on a perf 
>> kprobes tool to exploit that.
> 
> Nice progress. What's the expected timeline of exhaustive tools/perf/ 
> support?

Hi Ingo,

That's under reviewing, I'll post it as soon as possible. :-)
Now I'm considering about it's interface.
In the 1st release, I'll use -P "probe-and-arg-definition" option
which I suggested perviously, but it is also possible to use
-p "event" -a "arg" option which Frederic suggested.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

