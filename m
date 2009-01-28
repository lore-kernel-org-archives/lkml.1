Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbZA1OF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbZA1OF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZA1N6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:58:32 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:60404 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZA1N6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xeRTfcE9tj2o7eDmz1SbIwrDbQEwCXQyfNwtmZq7tNa3eoiLKoqoFsxwFreWCVj4yc
         +7JOYgJsCO9wcBZImHewLxzC6VurdTpUem1rMtzFryTJC2uWL+nevvcPAFtc5fQ8zrYg
         KhNLWlcDObc56p0ohDj80dTXcX8AU1g2vDL8M=
MIME-Version: 1.0
In-Reply-To: <y0mtz7ks1jf.fsf@ton.toronto.redhat.com>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <y0mtz7ks1jf.fsf@ton.toronto.redhat.com>
Date: Wed, 28 Jan 2009 14:58:28 +0100
Message-ID: <c62985530901280558o7b7572efl8afeebb33b463e2b@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Neil Horman <nhorman@tuxdriver.com>, utrace-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Frank Ch. Eigler <fche@redhat.com>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> [...]
>> Speaking about a global syscall tracer, I made a patch to trace only the syscalls
>> with the function-graph-tracer.
>> http://lkml.org/lkml/2008/12/30/267 This low-level part can easily
>> be used by all tracers that would like to inspect syscalls.
>> [...]
>> Just a change is needed: Steven requested that the part inside
>> syscall_trace_enter become a tracepoint, making it totally shareable
>> between tracers and easy to turn on and off.
>
> Alternately, you could just rely on utrace's hooks.  They were thought
> out more fully with respect to parameter access, manipulation, and
> programmatic control befitting even a debugger.
>
>
> - FChE
>

I don't know much it. But I will soon have some time to look at your
patch which uses ftrace from utrace.
Anyway, are there some plans about utrace to be merged? Unless I
couldn't be able to use
it...
