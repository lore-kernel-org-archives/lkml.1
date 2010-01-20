Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550Ab0ATMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0ATMYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137Ab0ATMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:24:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0ATMYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:24:36 -0500
Message-ID: <4B56F5DE.1060405@redhat.com>
Date: Wed, 20 Jan 2010 14:23:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com> <4B545146.3080001@redhat.com> <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <4B56D027.3010808@redhat.com> <20100120104541.GB30109@linux.vnet.ibm.com>
In-Reply-To: <20100120104541.GB30109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 12:45 PM, Srikar Dronamraju wrote:
>>> What does the code in the jumped-to vma do?
>>>        
>> 1. Write a trace entry into shared memory, trap into the kernel on overflow.
>> 2. Trap if a condition is satisfied (fast watchpoint implementation).
>>      
> That looks to be a nice idea. We should certainly look into this
> possibility. However can we look at this option probably a little later?
>
> Our plan was to do one step at a time i.e have the basic uprobes in
> first and target the booster (i.e jump to the next instruction without
> the need for single-stepping next).
>
> We could look at this option of using jump instead of int3 after we are
> done with the booster.  Hope that's okay.
>    

I'm all for incremental development and merging, as long as we keep the 
interfaces flexible enough for the future.

-- 
error compiling committee.c: too many arguments to function

