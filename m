Return-Path: <linux-kernel-owner+w=401wt.eu-S1763794AbXIXQqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763794AbXIXQqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbXIXQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:32:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46839 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759423AbXIXQcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:32:08 -0400
Message-ID: <46F7E685.4020609@us.ibm.com>
Date: Mon, 24 Sep 2007 09:32:05 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, David Wilder <dwilder@us.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (resend)
References: <1190435014.27362.16.camel@lc4eb748232119.ibm.com> <20070922093508.GC27827@infradead.org> <46F7D9FA.3090108@us.ibm.com> <20070924154114.GA25368@infradead.org>
In-Reply-To: <20070924154114.GA25368@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Sep 24, 2007 at 08:38:34AM -0700, David Wilder wrote:
>>> NACK, don't put code into Documentation/.  Put it into kernel as it's
>>> actually useful kernel code.  
>> Are you suggesting moving the example code into kernel? Or complaining 
>> about example code in /Documentation?
> 
> Both.  example code should be integrated with the build system so it
> gets built.

I agree, but I have not seen this done before, can you point me at an 
example of how to structure this?

> 
>> And add clone,exec and exit while you're at it.
>>
>> Hu?  A syscall tracer sounds like a nice idea but that is not what I am 
>> trying to accomplish.  I will let Systemtap handle that.
> 
> Systemtap doesn't help anyone as it's not in the tree.  I haven't even
> asked you to provide a full system call tracing modulem but provide at
> least one that's useful for a certain use-case (looking at processes)
> instead of almost useless code.
> 

I don't have a problem adding additional trace points to the example 
code.  However, anyone trying to use the code for some real purpose will 
want to tweak the code based on their needs, at a minimum to select what 
data to trace.  I don't think we gain much by adding more to the example 
other than to make it more complicated.  I am strong believer in keeping 
example code as simple as possible.

If you are suggesting adding a separate feature for process tracing (not 
just an example) that is a good idea also.  But is should be a separate 
patch, not part of the trace patch.
