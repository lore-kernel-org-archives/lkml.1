Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYLCKXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYLCKXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 05:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYLCKXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 05:23:45 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:54208 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYLCKXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 05:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v3HQR25pgiixuA/c8a/4jagZ5nrMYTkWbrgIInKAnOxadqyZwKCdeavycSThHABLpr
         Y5rotCaf8sK8qQAEQpJriWFZu7F0WBU1zlw5IXQaR0I5yuGHQWYMvsuERZu3GJsIerB3
         98J/4A0NCgslRx9Y5AXxQJSuUpAWl5LCHazTU=
Message-ID: <c62985530812030223o4af19ab7idec0894bcdd275d@mail.gmail.com>
Date: Wed, 3 Dec 2008 11:23:43 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1228299706.9673.115.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu> <20081203083332.GA5455@elte.hu>
	 <c62985530812030207l75084154vf1f94fe22ab0448@mail.gmail.com>
	 <1228299706.9673.115.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2008-12-03 at 11:07 +0100, Frédéric Weisbecker wrote:
>>
>>
>> >
>> > btw., i tested the graph tracer on a 16-way 64-bit box as well, and
>> the
>> > multi-digit CPU field printout magic works fine there too:
>> >
>> >  9)               |    pick_next_task() {
>> >  9)   0.283 us    |      pick_next_task_fair();
>> >  9)   0.276 us    |      pick_next_task_rt();
>> >  9)   0.273 us    |      pick_next_task_fair();
>> >  9)   0.279 us    |      pick_next_task_idle();
>> >  9)   2.596 us    |    }
>> >  9)   0.566 us    |    __lock_text_start();
>> >  10)   0.299 us    |        }
>> >  10)               |        mm_init() {
>> >  10)               |          pgd_alloc() {
>> >  10)               |            __get_free_pages() {
>> >  10)               |              alloc_pages_current() {
>> >  10)   0.330 us    |                policy_zonelist();
>> >  10)               |                __alloc_pages_internal() {
>> >
>> >        Ingo
>> >
>>
>> Hmm not really, there should be one space more before the 9 to fit the
>> log10(MAX_CPU) here and not break
>> the column.
>
> It did in my copy of Ingo's email...


So perhaps I should drop gmail...... :-(
