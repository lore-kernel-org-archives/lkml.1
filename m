Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbZFIIPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbZFIIPC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZFIIOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:14:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50506 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbZFIIOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:14:42 -0400
Message-ID: <4A2E19A7.1000302@kernel.org>
Date: Tue, 09 Jun 2009 01:13:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/cpufreq: use cpumask_copy instead of =
References: <4A2835D8.6040903@kernel.org> <4A2AE4AC.60805@kernel.org> <4A2AE570.2010307@kernel.org> <200906091627.45411.rusty@rustcorp.com.au>
In-Reply-To: <200906091627.45411.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sun, 7 Jun 2009 07:23:52 am Yinghai Lu wrote:
>   
>> so later could use nr_cpumask_bits in cpumask_size when MAXSMP is used
>>     
>
> I have a (more ambitious) patch for this in my queue, which weans it off this
> entirely:
>
> Subject: cpumask: avoid playing with cpus_allowed in powernow-k8.c
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> It's generally a very bad idea to mug some process's cpumask: it could
> legitimately and reasonably be changed by root, which could break us
> (if done before our code) or them (if we restore the wrong value).
>
> I use work_on_cpu, which is slightly less efficient than the old code,
> but the code is complex enough that using smp_call_function_single()
> is not trivial.
>   

will be in .31?

YH
