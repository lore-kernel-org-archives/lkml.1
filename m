Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZCHD0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZCHD0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 22:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZCHD0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 22:26:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:1510 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZCHD0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 22:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YC03Y0hQrcgKt4hpyOJASPmOxjrN6MrnKDjIzG5BiOnawPhWfVmGFIGuKzZscixDb3
         gxsGBd2nE4PD0RDCYXj/aLUSX0fxwuxu5SHVOIn8EvfMQYymxUaUeexvLlg2qbYD9CNr
         9N9a89WWNSbfzLm+A9dHWdoT/jgQinWyOsqtI=
MIME-Version: 1.0
In-Reply-To: <20090307153427.GA6075@nowhere>
References: <20090307235209.5A84.A69D9226@jp.fujitsu.com>
	 <20090307153427.GA6075@nowhere>
Date: Sun, 8 Mar 2009 12:26:33 +0900
X-Google-Sender-Auth: 0d2f16dfddbb8c26
Message-ID: <2f11576a0903071926u3eeb793fx44300a0257439535@mail.gmail.com>
Subject: Re: [PATCH for tip] ftrace: remove latency_trace document
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/8 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sat, Mar 07, 2009 at 11:53:40PM +0900, KOSAKI Motohiro wrote:
>> Subject: [PATCH] remove latency_trace document
>>
>> Currently, there aren't "Latency tracer" and latency_trace file.
>> Then, its documentation is removed too.
>
> Hi,
>
> The latency_trace file has been removed but the latency tracing stil exists.
> It has become an option instead of a file now:
>
> echo latency-format > /debugfs/tracing/trace_options
>
> There are even some tracers that default enable it (irqsoff, preemptoff...)
> IMO, the documentation about latency tracing shouldn't be removed but
> just updated a bit to reflect this change.

Ah, sorry.
I totally misunderstood it.

thanks to correct my fault.
