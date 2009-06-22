Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZFVQaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZFVQaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFVQac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:30:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54762 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZFVQab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:30:31 -0400
Message-ID: <4A3FB1A5.3060805@us.ibm.com>
Date: Mon, 22 Jun 2009 09:30:29 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       niv@us.ibm.com, lethal@linux-sh.org, kernel@wantstofly.org,
       matthew@wil.cx
Subject: Re: [PATCH] v4 RCU: the bloatwatch edition
References: <20090506225115.GM6771@linux.vnet.ibm.com> <20090506112459.5edd0902.akpm@linux-foundation.org> <20090502163423.GA1633@linux.vnet.ibm.com> <12234.1241558327@redhat.com> <20090506120909.GR25203@elte.hu> <11979.1241648574@redhat.com> <26931.1245670998@redhat.com> <20090622124951.GB30553@elte.hu> <20090622082941.c5c8b3f3.akpm@linux-foundation.org> <20090622160753.GE6754@linux.vnet.ibm.com>
In-Reply-To: <20090622160753.GE6754@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Jun 22, 2009 at 08:29:41AM -0700, Andrew Morton wrote:
>> On Mon, 22 Jun 2009 14:49:51 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> * David Howells <dhowells@redhat.com> wrote:
>>>
>>>> Hi Paul,
>>>>
>>>> Are you going to push your RCU patch for this merge window?
>>> Andrew needs to be convinced for that to happen.
>>>
>> whome?  I rarely have firm opinions on anything.  iirc the question
>> here was "is it worth adding another RCU implementation to save 900
>> bytes"?
>>
>> I find it pretty hard to see how to come up with "yes" for that one but
>> it's hardly a huge issue.  If you guys feel otherwise then go wild.
> 
> Well, I do need to pull the "expedited" interface into the bloatwatch
> version, and my update of rcutorture made me realize that I can cut
> out a few more bytes, so I will submit an update.  For what it is worth,
> here are the opinions expressed on LKML:
> 
> +	Ingo Molnar: good documentation, minimal RCU implementation.
> ?	Andi Kleen: will there be !SMP systems in the future?
> +	Lennert Buytenhek: there will be !SMP ARM for a long time.
> +	Paul Mundt: good idea for more-constrained SH platforms.
> +	David Howells: Acked-by.  works on FRV board.
> ?	Andrew Morton: do we really need another RCU implementation?
> 
> Of course, I well remember programming systems with 4K of core memory
> back in the 1970s, and therefore feel a bit guilty about sticking deep
> embedded platforms with the increase in memory footprint represented
> by Hierarchical RCU compared to Classic RCU.  And Bloatwatch RCU is much
> smaller and easier to understand/maintain than is Classic RCU.
> 
> So, again, I will forward port, optimize, test, and resubmit.

IIRC, in previous threads on this topic, the Bloatwatch edition was 
expected to replace Classic RCU.  If so, wouldn't that address Andrew's 
concern of "adding" another implementation?

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
