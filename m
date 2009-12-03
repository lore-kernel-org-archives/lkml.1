Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZLCQMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZLCQMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZLCQMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:12:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZLCQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:12:14 -0500
Message-ID: <4B17E337.8070301@redhat.com>
Date: Thu, 03 Dec 2009 11:11:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, wcohen@redhat.com, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com,
       linux-tip-commits@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
References: <20091202144334.GA30359@elte.hu>	 <1259765735.12870.42.camel@gandalf.stny.rr.com>	 <20091202162715.GB9710@Krystal>	 <1259773888.12870.61.camel@gandalf.stny.rr.com>	 <20091202180633.GF9710@Krystal>	 <1259777987.12870.70.camel@gandalf.stny.rr.com>	 <20091202190135.GA23316@Krystal>	 <1259781578.12870.78.camel@gandalf.stny.rr.com>	 <4B16EC06.6010706@redhat.com>	 <1259794005.12870.102.camel@gandalf.stny.rr.com>	 <20091202231019.GB14770@Krystal>  <4B1737E2.6010502@redhat.com>	 <1259813228.12870.108.camel@gandalf.stny.rr.com>	 <4B17C25A.8090703@redhat.com>	 <1259848493.12870.114.camel@gandalf.stny.rr.com>	 <4B17D9D1.7010402@redhat.com> <1259855773.12870.137.camel@gandalf.stny.rr.com>
In-Reply-To: <1259855773.12870.137.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2009-12-03 at 10:31 -0500, Masami Hiramatsu wrote:
>> Steven Rostedt wrote:
> 
>>>> Would you mean putting those headers in sub-system's directory?
>>>> (e.g. fs/ext4/)
>>>> In that case, a problem will happen when user want to hook those
>>>> tracepoint from their module, because it is hard to find those
>>>> local headers.
>>>
>>> Why? Modules usually do have their own headers in their sub system.
>>
>> Module's local headers usually uses only from itself. Other modules
>> may not touch it. However, AFAIK, event definitions must be referred
>> by event consumer which is another module. IOW, those local headers
>> will not be included in kernel-headers/kernel-devel package :-(
> 
> I'm a little confused. Who is the event consumer? The trace point user?
> The one that hooks into the tracepoint?

Ah, I meant the tracepoint user module, not the ftrace event consumer.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

