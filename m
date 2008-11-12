Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYKLWWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYKLWWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYKLWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:22:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:27715 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYKLWWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vfgJ0m1K+1HD1IMXmRcRYjQ8MY0keNubo6h+LzbvcQut5SW7d3pDtFnvsYHGeRe6Mq
         XqEZp6AMcH2Fk0dQO+jgsfwUY9rZ0iaKrhzGNjbMyD2kBJxEA5evLlM5H9C6R4rbrdoB
         JTeYC//WIY2UFD2KnCMewO0xM0pvgQ2l0aOUY=
Message-ID: <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
Date: Wed, 12 Nov 2008 23:22:37 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081112221623.GB6125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: Optimize a bit the function return tracer
>>
>> This patch changes the calling convention of prepare_ftrace_return
>> to pass its arguments by register. This will optimize it a bit and
>> prepare it to support dynamic tracing.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  arch/x86/kernel/entry_32.S |    5 +----
>>  arch/x86/kernel/ftrace.c   |    1 -
>>  2 files changed, 1 insertions(+), 5 deletions(-)
>
> applied to tip/tracing/function-return-tracer, thanks Frederic!
>
> btw., should we now rename it all to the function-cost tracer?
>
>        Ingo
>


Yes. I'm preparing a patch to do these renames....
