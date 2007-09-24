Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbXIXPiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbXIXPiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbXIXPii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:38:38 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56456 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930AbXIXPih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:38:37 -0400
Message-ID: <46F7D9FA.3090108@us.ibm.com>
Date: Mon, 24 Sep 2007 08:38:34 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       "David J. Wilder" <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (resend)
References: <1190435014.27362.16.camel@lc4eb748232119.ibm.com> <20070922093508.GC27827@infradead.org>
In-Reply-To: <20070922093508.GC27827@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 21, 2007 at 09:23:28PM -0700, David J. Wilder wrote:
>> My last posting was mangled by my mailer.  I hope this one is better.
>> Also corrected Randy's concerns.
>>
>> Please see previous posting for more information:
>> http://lkml.org/lkml/2007/9/19/4 (PATCH 0/2)
>>
>> Note: this patch requires "[Patch 2/2] Relay reset consumed" is applied.
>>
>> ---------<start of patch>------------
>> Trace - Provides tracing primitives
>>
>> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
>> Signed-off-by: Martin Hunt <hunt@redhat.com>
>> Signed-off-by: David Wilder <dwilder@us.ibm.com>
>> ---
>>  Documentation/trace/src/Makefile     |    7 +
>>  Documentation/trace/src/README       |   18 +
>>  Documentation/trace/src/fork_trace.c |  119 +++++++
>>  Documentation/trace/trace.txt        |  164 ++++++++++
> 
> NACK, don't put code into Documentation/.  Put it into kernel as it's
> actually useful kernel code.  

Are you suggesting moving the example code into kernel? Or complaining 
about example code in /Documentation?

And add clone,exec and exit while you're at it.

Hu?  A syscall tracer sounds like a nice idea but that is not what I am 
trying to accomplish.  I will let Systemtap handle that.

