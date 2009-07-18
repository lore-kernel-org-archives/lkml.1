Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbZGRNaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbZGRNaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 09:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZGRNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 09:30:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:45149 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751638AbZGRNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 09:30:06 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18kyG5eNuIkVDGyDyAShpQVeMi2MW3i4U+WjtP5yJ
	RxuEGnmJLj36Vl
Message-ID: <4A61CE59.3030905@fisher-privat.net>
Date: Sat, 18 Jul 2009 15:30:01 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
 all .data.* sections on X86_64)
References: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com> <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com> <4A5C5A59.5080304@fisher-privat.net> <1247567499.28240.48.camel@pc1117.cambridge.arm.com> <4A5C5FD0.3020204@fisher-privat.net> <1247574390.28240.67.camel@pc1117.cambridge.arm.com> <20090715080336.GA4823@skywalker> <4A5D9939.3000500@fisher-privat.net> <20090718115556.GA31007@elte.hu>
In-Reply-To: <20090718115556.GA31007@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Alexey Fisher <bug-track@fisher-privat.net> wrote:
> 
>> This patch work for me.
> 
> nice. Any leftovers that might be false positives and need 
> annotation?
> 
> We learned this with lockdep: the moment a typical x86 distro bootup 
> is 'warnings free', utility of the debugging facility increases 
> dramatically: people can standardize on 'kmemleak should never 
> produce warnings' workflows and distros can also start feeding 
> kmemleak reports into kerneloops.org or so.
> 
> So the general direction kmemleak is moving into is really 
> encouraging.
> 
> 	Ingo

suddenly my kernel is not warning free... i have still warning about 
acpi_init, cpufreg, intel_gem and inoitfy on my PC and about firmware 
loader on my laptop. So i think there is still some job to do. I will 
report this warnings soon.
