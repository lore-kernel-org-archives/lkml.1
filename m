Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYKYPtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYKYPtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYKYPto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:49:44 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:63966 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYKYPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=C5frv4Bo3nOrgzM+v1UiZsvEtUlg4MYXuiCPr4PUpSjWmi9k2Mkef5Ox7pVLrg54zF
         5G+YS1uScrpO/O5Y9Xjip3zkMItdIUXm2ZOh1KCiwXDRDXnQcvdfj+jR4YInj43uS/fc
         tE3DM7adzWvV/shkxE8S8esg4VYqNpFWt89dk=
Message-ID: <c62985530811250749mc2e15f9lf080df7d1c444f5a@mail.gmail.com>
Date: Tue, 25 Nov 2008 16:49:42 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Human readable output for function return tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081125154054.GA21493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
	 <20081124162719.GA11532@elte.hu>
	 <c62985530811250718q3aa5f2ednd795b7c927abb8e4@mail.gmail.com>
	 <20081125153653.GA21001@elte.hu> <20081125154054.GA21493@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/25 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > Do you agree with "full function tracer" (since we hook now on the
>> > two sides)?
>>
>> "full function tracer" sounds a bit funny and quirky. How about
>> "function call tracer"? Versus the "function tracer" or "function
>> entry tracer" which is the lighter variant - both in name and in
>> overhead. So we'd have:
>>
>>  # cat /debug/tracing/available_tracers
>>  mmiotrace wakeup irqsoff function function-call sysprof sched_switch initcall nop
>>
>> note how intuitive it is: "function-call" is 'more' than just the
>> plain function-tracer. It also expresses its main property: it
>> traces the full call, entry and exit and return code as well.
>
> another similar naming would be: the "function-graph" tracer.
> function-callgraph would be too long.
>
> i think "function-call" is the best of all - relatively short and
> expressive.
>
>        Ingo
>

Ok. No problem for me. But if ftrace is not renamed to ftrace-entry, I
think that it will be
confusing...
