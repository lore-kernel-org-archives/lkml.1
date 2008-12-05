Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbYLEOB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbYLEOB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 09:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYLEOBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 09:01:18 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:64420 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYLEOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 09:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ovIiZidwMXXrpDiy3Kxx56XkXXj8JQy3a06KlKZm26LcMhoj5hqOCNDjodBJBwfnXa
         0jlmh2MGTlCGwhETV59VfK1EI2uYGaUe/kPQEb+NpJviYe4UF3x+Vqoc/H4itaLYSCyi
         /YH3te2rXF0YJSR+H4Dkuv24IvNR8C7dHArdY=
Message-ID: <c62985530812050601p1f826470l13fccf42fb9e9ff8@mail.gmail.com>
Date: Fri, 5 Dec 2008 15:01:15 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/3] tracing/ftrace: don't insert TRACE_PRINT during selftests
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081205134818.GA27039@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49385E07.7050304@gmail.com> <20081205134818.GA27039@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/5 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: fix tracer selfstests false results
>>
>> After setting a ftrace_printk somewhere in th kernel, I saw the
>> Function tracer selftest failing.
>>
>> When a selftest occurs, the ring buffer is lurked to see if
>> some entries were inserted. But concurrent insertion such as
>> ftrace_printk could occured at the same time and could give
>> false positive or negative results.
>>
>> This patch prevent prevent from TRACE_PRINT entries insertion
>> during selftests.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/trace.c |   13 ++++++++++++-
>>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> applied to tip/tracing/ftrace, thanks.
>
> I suspect you'll also fix the things Steve pointed out?


Yes of course :-)
