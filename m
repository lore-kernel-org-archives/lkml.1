Return-Path: <linux-kernel-owner+w=401wt.eu-S1757224AbZCLQbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224AbZCLQbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZCLQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:31:14 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:23089 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZCLQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:31:13 -0400
Message-ID: <49B9391C.8020101@oracle.com>
Date: Thu, 12 Mar 2009 09:32:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for March 11 (tracing)
References: <20090311225913.51589223.sfr@canb.auug.org.au>	 <49B7F691.5000305@oracle.com>  <49B93584.3020302@oracle.com> <1236875181.11290.1.camel@localhost.localdomain>
In-Reply-To: <1236875181.11290.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49B938A8.0082:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-03-12 at 09:17 -0700, Randy Dunlap wrote:
>> [adding cc:s]
>>
>> [same report for March 12]
>>
>> Randy Dunlap wrote:
>>> Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20090310:
>>>
>>> Building on i386 generates a ton of printk format warnings:
>>>
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 6 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 9 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 10 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 14 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 18 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'unsigned int'
>>> kernel/trace/trace_events.c:470: warning: format '%lu' expects type 'long unsigned int', but argument 22 has type 'unsigned int'
>>>
> 
> I believe this is corrected in Ingo's tip tree. I changed %lu to %zu to
> handle the "sizeof()" case. The fix was suggested by Andrew Morton.

OK, thanks for the info.

-- 
~Randy
