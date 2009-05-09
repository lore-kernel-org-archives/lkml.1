Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZEIOM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZEIOM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZEIOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:12:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52117 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIOMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lbJkWS91qAW1sa43eeliXhoU5V8H1XRfeT6FTyMsuBZmSMZMTtPaas+eWN8CqTPGM6
         MyexEBstef66tGHe2o0QU9ocq0EQ1133SQBgHUoOkV6NUlnWC/b21z+vwUtgy7DlEuKo
         H2+dzUNDmxxEf/9LjuCdM7aXXfamUoPpkkZwQ=
MIME-Version: 1.0
In-Reply-To: <20090509140717.GB22000@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
	 <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
	 <20090509133306.GA20684@elte.hu>
	 <c62985530905090702o536c8787m1910540d560a0a22@mail.gmail.com>
	 <20090509140717.GB22000@elte.hu>
Date: Sat, 9 May 2009 16:12:16 +0200
Message-ID: <c62985530905090712l59de17fbh2085119f2574255a@mail.gmail.com>
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 9 mai 2009 16:07, Ingo Molnar <mingo@elte.hu> a écrit :
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > Note, this assumes that all syscall types can be described via
>> > __field() - i think that's correct. (we dont want to deref
>> > strings as they are untrusted, and there are no arrays in
>> > syscall parameters)
>>
>> Yeah, but we can also define a __string_from_user(), should be
>> trivial.
>
> We cannot really do that, because we cannot check the type in a
> macro. So we dont know when to inject __field() versus
> __string_from_user().


Aah...you're right :-/



>
>> > Can you see any complication?
>>
>> Just about the order of headers to include and headers
>> dependencies....
>
> That is testable and any problems will be found at the build stage,
> so it should be solvable.
>
>        Ingo
>
