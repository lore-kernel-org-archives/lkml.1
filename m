Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZLCDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZLCDWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZLCDWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:22:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZLCDWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:22:16 -0500
Message-ID: <4B172F51.1090507@redhat.com>
Date: Wed, 02 Dec 2009 22:24:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: trace/events: DECLARE vs DEFINE semantic
References: <20091202162715.GB9710@Krystal> <1259773888.12870.61.camel@gandalf.stny.rr.com> <20091202180633.GF9710@Krystal> <1259777987.12870.70.camel@gandalf.stny.rr.com> <20091202190135.GA23316@Krystal> <1259781578.12870.78.camel@gandalf.stny.rr.com> <4B16EC06.6010706@redhat.com> <1259794005.12870.102.camel@gandalf.stny.rr.com> <20091202225736.GA14770@Krystal> <4B16F389.4090801@zytor.com> <20091202231529.GC14770@Krystal>
In-Reply-To: <20091202231529.GC14770@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> On 12/02/2009 02:57 PM, Mathieu Desnoyers wrote:
>>>>
>>>> TRACE_CLASS - Declares a class
>>>> TRACE_CLASS_EVENT - defines an event for said class
>>>> TRACE_EVENT - Declares a class and defines an event (as is today)
>>>
>>> Yep, it looks good! It's self-descriptive and don't require to explain
>>> what the thing is doing each time we refer to it. (however I feel a bit
>>> sad for Fred, Wilma and Barney) ;)
>>>
>>
>> Although you have to admit it's a bit confusing that:
>>
>> TRACE_EVENT = TRACE_CLASS + TRACE_CLASS_EVENT
>>
>> ... as opposed to ...
>>
>> TRACE_CLASS_EVENT = TRACE_CLASS + TRACE_EVENT
>>
>> 	-hpa
> 
> Then I would say that TRACE_EVENT should probably not have the
> side-effect of declaring a globally-reuseable class. Maybe under the
> hood it could create a privately-named class, but I don't see how it can
> be re-used by following TRACE_CLASS_EVENT without causing confusion.
> 
> I'd go for:
> 
> TRACE_CLASS - Declares/defines a class
> TRACE_CLASS_EVENT - Declares/defines an event for said class
> TRACE_EVENT - Declares/defines a private class and declares/defines an event

Agreed, I'd rather like this naming. :-)

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

