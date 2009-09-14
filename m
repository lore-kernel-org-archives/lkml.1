Return-Path: <linux-kernel-owner+w=401wt.eu-S933838AbZINUV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbZINUV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933834AbZINUV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:21:56 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:60220 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbZINUVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LPkNQ0ArnzlU2koEF4HkWjm4qjHLL6qxiow4JrKU+Pj3Qy0KX5WiJZuZYFpLMnG8QC
         Z52yL3/s9bEAIYgRHVThg9lCXro4tq1cJ/F+JmotSjiGvT43NptCFxcOGA3AMEjqaynK
         Lt7xipzVjg/9ucFksYQtFVYULGMrUpbJPTB2s=
MIME-Version: 1.0
In-Reply-To: <1252957702.20020.53.camel@gandalf.stny.rr.com>
References: <20090614012457.GD5986@nowhere> <1244948719-22216-1-git-send-email-vapier@gentoo.org> 
	<1252957702.20020.53.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 16:21:35 -0400
Message-ID: <8bd0f97a0909141321t515648c7ue0a7d377b99f13f5@mail.gmail.com>
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 15:48, Steven Rostedt wrote:
> On Sat, 2009-06-13 at 23:05 -0400, Mike Frysinger wrote:
>> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
>> index fd9a3e6..95a39fb 100644
>> --- a/Documentation/trace/ftrace.txt
>> +++ b/Documentation/trace/ftrace.txt
>> @@ -27,6 +27,12 @@ disabled, and more (ftrace allows for tracer plugins, which
>>  means that the list of tracers can always grow).
>>
>>
>> +Implementation Details
>> +----------------------
>> +
>> +See ftrace-implementation.txt for details for arch porters and such.
>
> Might want to specify that this is for the function tracer.

well, all of ftrace.txt says "function tracer", so if/when someone
cleans that up, this will get fixed in the process.

>> --- a/kernel/trace/Kconfig
>> +++ b/kernel/trace/Kconfig
>> @@ -11,31 +11,41 @@ config NOP_TRACER
>>
>>  config HAVE_FTRACE_NMI_ENTER
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_FUNCTION_TRACER
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_FUNCTION_GRAPH_TRACER
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_FUNCTION_TRACE_MCOUNT_TEST
>>       bool
>>       help
>> -      This gets selected when the arch tests the function_trace_stop
>> -      variable at the mcount call site. Otherwise, this variable
>> -      is tested by the called function.
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_DYNAMIC_FTRACE
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_FTRACE_MCOUNT_RECORD
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config HAVE_HW_BRANCH_TRACER
>>       bool
>>
>>  config HAVE_FTRACE_SYSCALLS
>>       bool
>> +     help
>> +       See Documentation/trace/ftrace-implementation.txt
>>
>>  config TRACER_MAX_TRACE
>>       bool
>
> Other than this, it looks good.

so you want me to drop the Kconfig pieces ?  there was discussion in
this thread about why the Kconfig pieces were here ...
-mike
