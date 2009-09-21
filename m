Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZIUHXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZIUHXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZIUHXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:23:11 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51895 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZIUHXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GUyznrCWt68BRxBSqTMJzFA2YiuZls+7LRC1VATRlQFTJL93RdIpMz6ZQ9FanfNt9c
         9V4AXK0l0WzXURO9jbq1DcbmofvLrMBElyVfq7yvFFhxBwCjjx2q7T/kBIkJhU5e4ECw
         AaDD+ziaZGZZrpYJE4A43Dj+zsJdmq0Bx6oFg=
MIME-Version: 1.0
In-Reply-To: <1253445829.20020.626.camel@gandalf.stny.rr.com>
References: <1253442878.7542.3.camel@laptop>
	 <1253445829.20020.626.camel@gandalf.stny.rr.com>
Date: Mon, 21 Sep 2009 09:23:12 +0200
Message-ID: <c62985530909210023p7707b9efwc4a994522e53fa72@mail.gmail.com>
Subject: Re: [PATCH] trace: export trace_profile_buf symbols
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: rostedt@goodmis.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20 septembre 2009 13:23, Steven Rostedt <rostedt@goodmis.org> a écrit :
> On Sun, 2009-09-20 at 12:34 +0200, Peter Zijlstra wrote:
>> ERROR: "trace_profile_buf_nmi" [fs/jbd2/jbd2.ko] undefined!
>> ERROR: "trace_profile_buf" [fs/jbd2/jbd2.ko] undefined!
>> ERROR: "trace_profile_buf_nmi" [fs/ext4/ext4.ko] undefined!
>> ERROR: "trace_profile_buf" [fs/ext4/ext4.ko] undefined!
>> ERROR: "trace_profile_buf_nmi" [arch/x86/kvm/kvm.ko] undefined!
>> ERROR: "trace_profile_buf" [arch/x86/kvm/kvm.ko] undefined!
>>
>
> Peter, I thought you never use modules.


And I forgot to think about them :-/


>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



>
> -- Steve
>
>> ---
>>  kernel/trace/trace_event_profile.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
>> index 3aaa77c..f65e966 100644
>> --- a/kernel/trace/trace_event_profile.c
>> +++ b/kernel/trace/trace_event_profile.c
>> @@ -17,6 +17,9 @@ typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
>>  char         *trace_profile_buf;
>>  char                 *trace_profile_buf_nmi;
>>
>> +EXPORT_SYMBOL_GPL(trace_profile_buf);
>> +EXPORT_SYMBOL_GPL(trace_profile_buf_nmi);
>> +
>>  /* Count the events in use (per event id, not per instance) */
>>  static int   total_profile_count;
>>
>>
>>
>
>
