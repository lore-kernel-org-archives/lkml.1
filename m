Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbXIDH3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbXIDH3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXIDH3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:29:33 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:38067 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXIDH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:29:32 -0400
Message-ID: <46DD0939.7030409@linux.vnet.ibm.com>
Date: Tue, 04 Sep 2007 08:28:57 +0100
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH] Memory controller improve user interface (v3)
References: <20070902105021.3737.31251.sendpatchset@balbir-laptop> <6599ad830709022153g1720bcedsb61d7cf7a783bd3f@mail.gmail.com> <46DC6543.3000607@linux.vnet.ibm.com> <6599ad830709040019r17861771we2a0893c0c160723@mail.gmail.com>
In-Reply-To: <6599ad830709040019r17861771we2a0893c0c160723@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 9/3/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Paul Menage wrote:
>>> On 9/2/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>> -       s += sprintf(s, "%lu\n", *val);
>>>> +       if (read_strategy)
>>>> +               s += read_strategy(*val, s);
>>>> +       else
>>>> +               s += sprintf(s, "%lu\n", *val);
>>> This would be better as %llu
>>>
>> Hi, Paul,
>>
>> This does not need fixing, since the other counters like failcnt are
>> still unsigned long
>>
> 
> But val is an unsigned long long*. So printing *val with %lu will
> break (at least a warning, and maybe corruption if you had other
> parameters) on 32-bit archs.
> 

Yeah... Hmm.. just wonder if all the counters should be unsigned long
long? failcnt is the only remaining unsigned long counter now.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
