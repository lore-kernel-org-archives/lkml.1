Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbYJJPGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbYJJPGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYJJPGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:06:30 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:63880 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718AbYJJPG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:06:29 -0400
Message-ID: <48EF6F3A.8080801@nortel.com>
Date: Fri, 10 Oct 2008 09:05:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: cgroup task groups appears sensitive to absolute magnitude of
 shares
References: <48EE8D06.9060503@nortel.com> <1223618594.7382.60.camel@lappy.programming.kicks-ass.net> <1223625237.7382.62.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223625237.7382.62.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Oct 2008 15:05:34.0152 (UTC) FILETIME=[A50BA480:01C92AE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-10-10 at 08:03 +0200, Peter Zijlstra wrote: 
>>On Thu, 2008-10-09 at 17:00 -0600, Chris Friesen wrote:

>>>Going to 4000/2000/1000/200 doesn't seem to give noticeable 
>>>improvements, and going to 40000/20000/10000/2000 causes the test to 
>>>behave unpredictably, either taking abnormally long to complete or else 
>>>not completing at all.
>>
>>Hmm, I would have expected it to work for at least the normal nice range
>>of weight values..
>>
>>Will have to look into that I suppose..

> One thought, are you running 32 or 64 bit? If you're on 32, could you
> try 64? If that fixes it its probably an easy fix, otherwise I fear it
> might take a bit more..

No such luck, this is 64-bit (powerpc though, not x86).  I tried 
reproducing it again today and was unable to reproduce the hang, but saw 
  delays of up to 7 seconds (where the expected delay is 10 sec).

Chris
