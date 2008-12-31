Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYLaBFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYLaBFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 20:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYLaBFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 20:05:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYLaBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 20:05:03 -0500
Message-ID: <495AC45D.8010102@kernel.org>
Date: Tue, 30 Dec 2008 17:01:17 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org> <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere>
In-Reply-To: <20081231004722.GA28472@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Dec 30, 2008 at 04:34:00PM -0800, H. Peter Anvin wrote:
>> H. Peter Anvin wrote:
>>> Applied to tip:tracing/kmemtrace2.
>>>
>> Hm, there still seems to be a build failure, in particular
>> trace_output.h is missing.  It looks to me at the moment as if just
>> removing the #include works; assuming that compiles I will check that in
>> to tip:tracing/kmemtrace2 as well.
>>
>> 	-hpa
> 
> While I worked on this tracer, I had to base the thing against tracing/kmemtrace
> because I needed the kmemtrace bits.
> But I saw that this topic was a bit out of sync against tip/master, some updates from
> Steven were not merged. But I didn't wonder, thinking that Ingo would resolve the
> conflicts. But it seems there were some lost stuffs :-)
> 
> I'm checking it and will send a patch to solve the rest...
> 

If it's only the trace_output.h #include removal, don't worry about it;
I'm about to commit that patch, but it would be good if you could check
out the tracing/kmemtrace2 branch afterwards.

	-hpa
