Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314Ab0ASIIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0ASIIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608Ab0ASIIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab0ASIIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:08:19 -0500
Message-ID: <4B556855.6040800@redhat.com>
Date: Tue, 19 Jan 2010 10:07:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <1263740593.557.20967.camel@twins>	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>	 <4B5459CA.9060603@redhat.com>  <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain>
In-Reply-To: <1263852957.2266.38.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 12:15 AM, Jim Keniston wrote:
>
>> I don't like the idea but if the performance benefits are real (are
>> they?),
>>      
> Based on what seems to be the closest thing to an apples-to-apples
> comparison -- counting the number of calls to a specified function --
> uprobes is 6-7 times faster than the ptrace-based equivalent, ltrace -c.
> And of course, uprobes provides much, much more flexibility, appears to
> scale better, and works with multithreaded apps.
>
> Likewise, FWIW, utrace is more than 10x faster than strace -c in
> counting system calls.
>
>    

This is still with a kernel entry, yes?  Do you have plans for a variant 
that's completely in userspace?

-- 
error compiling committee.c: too many arguments to function

