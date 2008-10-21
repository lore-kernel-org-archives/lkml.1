Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYJUM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYJUM17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYJUM1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:27:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752790AbYJUM1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:27:48 -0400
Message-ID: <48FDCAFB.3070802@sgi.com>
Date: Tue, 21 Oct 2008 05:28:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       davej@codemonkey.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, IA64 <linux-ia64@vger.kernel.org>,
       S390 <linux-s390@vger.kernel.org>, peterz@infradead.org,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, PowerPC <linuxppc-dev@ozlabs.org>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       SPARC <sparclinux@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 01/35] x86: clean up speedctep-centrino and reduce cpumask_t
 usage
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>	<20081020170319.730428000@polaris-admin.engr.sgi.com> <20081021110925.853227d6.sfr@canb.auug.org.au>
In-Reply-To: <20081021110925.853227d6.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Mike,
> 
> Just a first small thing:
> 
> On Mon, 20 Oct 2008 10:03:20 -0700 Mike Travis <travis@sgi.com> wrote:
>> 1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
>> 2) The loop can simply skip over offline cpus, rather than creating a tmp mask.
>> 3) set_mask is set to either a single cpu or all online cpus in a policy.
>>    Since it's just used for set_cpus_allowed(), any offline cpus in a policy
>>    don't matter, so we can just use cpumask_of_cpu() or the policy->cpus.
>>
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Mike Travis <travis@sgi.com>
> 
> The From: line should be the first nonempty line in the mail to get the
> attribution correct.
> 

Ahh, ok, thanks!
