Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbZCRQqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbZCRQqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZCRQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:46:33 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62085 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbZCRQqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:46:32 -0400
Message-ID: <49C124DE.9090001@oracle.com>
Date: Wed, 18 Mar 2009 09:44:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <srostedt@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: Tree for March 11 (tracing)
References: <20090311225913.51589223.sfr@canb.auug.org.au> <49B7F691.5000305@oracle.com> <49B93584.3020302@oracle.com> <1236875181.11290.1.camel@localhost.localdomain> <20090318084651.3dbf01e3.randy.dunlap@oracle.com> <20090318160621.GA21331@elte.hu> <49C11DB4.3070500@oracle.com> <20090318163228.GD21331@elte.hu>
In-Reply-To: <20090318163228.GD21331@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49C12456.0164:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>
>>>> On Thu, 12 Mar 2009 12:26:21 -0400 Steven Rostedt wrote:
>>>>
>>>>> On Thu, 2009-03-12 at 09:17 -0700, Randy Dunlap wrote:
>>>>>> [adding cc:s]
>>>>>>
>>>>>> [same report for March 12]
>>>>>>
>>>>>> Randy Dunlap wrote:
>>>>>>> Stephen Rothwell wrote:
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> Changes since 20090310:
>>>>>>> Building on i386 generates a ton of printk format warnings:
>>>>>>>
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
>>>>>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'
>>>>>>>
>>>>> I believe this is corrected in Ingo's tip tree. I changed %lu to %zu to
>>>>> handle the "sizeof()" case. The fix was suggested by Andrew Morton.
>>>> This build warning is still around (20090318).
>>>> Is the fix not in some branch that is imported into linux-next or what?
>>> be patient.
>>>
>>> 	Ingo
>> I think that 7 days is being patient for a simple build fix.
> 
> s/build fix/harmless build warning fix

180+ lines of noise in a build log.

> If you are interested in having a resolution you can git-merge the 
> latest development tree yourself and you can get rid of that 
> warning.
> 
> Of course that way you'd expose yourself to even fresher code, 
> potentially with much more serious breakages.
> 
> It's a balance of freshness versus stability, and that balance is 
> kept by maintainers.
> 
> If you want the latest development code - go engage with the 
> development trees directly.
> 
> If you want something that is relatively new (i.e. 1-2 weeks fresh) 
> but works on the range of systems we test, use what you get in 
> linux-next.
> 
> It's your choice which one you pick.
> 
> But you cannot have both.
> 
> If you genuinely think you can have it both, by all means i 
> encourage you to try it - it's all open source so you can run your 
> own tree. Just please dont feel entitled to demand it from others.

Thanks for the explanation.  That's what I tried to ask for
to begin with.  I guess that I have a language problem.

-- 
~Randy
