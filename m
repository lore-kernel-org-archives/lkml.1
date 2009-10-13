Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbZJMNgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbZJMNgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbZJMNgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:36:06 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48179 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923AbZJMNgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x3z8bjq0sIBLLheIetDDxFjTtIqsDjz8nWZAzpFleB68ggIRgEl8a1CW7e0x+ZEkfK
         1LUIPZRO2+m0d/ULyFIiphDtbrbkizz/lYWFCOg4aUUi65RdcKZiU2K8rAjMHL5od8D/
         0CFwYLrd5s7I83TZoEafC6122QUNpuShFEfqk=
MIME-Version: 1.0
In-Reply-To: <1255440127.7113.1551.camel@gandalf.stny.rr.com>
References: <1255419540-5481-1-git-send-email-fweisbec@gmail.com>
	 <1255419540-5481-3-git-send-email-fweisbec@gmail.com>
	 <1255440127.7113.1551.camel@gandalf.stny.rr.com>
Date: Tue, 13 Oct 2009 15:35:26 +0200
Message-ID: <c62985530910130635k3127d163u3c6b6a46a96e3ffb@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing: Rename set_ftrace to set_bootup_ftrace
From: Frederic Weisbecker <fweisbec@gmail.com>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/13 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2009-10-13 at 09:38 +0200, Frederic Weisbecker wrote:
>> Do this rename because set_ftrace is too much generic and not enough
>> self-explainable as a name.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 4506826..866daf8 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -129,7 +129,7 @@ static int tracing_set_tracer(const char *buf);
>>  static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
>>  static char *default_bootup_tracer;
>>
>> -static int __init set_ftrace(char *str)
>> +static int __init set_bootup_ftrace(char *str)
>>  {
>>       strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
>>       default_bootup_tracer = bootup_tracer_buf;
>> @@ -137,7 +137,7 @@ static int __init set_ftrace(char *str)
>>       ring_buffer_expanded = 1;
>>       return 1;
>>  }
>> -__setup("ftrace=", set_ftrace);
>> +__setup("ftrace=", set_bootup_ftrace);
>
> Actually, it probably should be called, set_cmdline_ftrace. Since it
> came from the command line, and that is what is matching.
>
> -- Steve

No problem, I can change that in another request that also addresses
Li's suggestion.
