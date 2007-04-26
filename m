Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbXDZTXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbXDZTXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbXDZTXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:23:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40143 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbXDZTXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:23:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<46303A98.9000605@yahoo.com.au>
	<20070426063830.GE32602149@melbourne.sgi.com>
	<m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704261103150.3263@schroedinger.engr.sgi.com>
	<m17irzkm8q.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704261155100.11420@schroedinger.engr.sgi.com>
Date: Thu, 26 Apr 2007 13:21:50 -0600
In-Reply-To: <Pine.LNX.4.64.0704261155100.11420@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Thu, 26 Apr 2007 11:59:43 -0700
	(PDT)")
Message-ID: <m1mz0vj60h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> On Thu, 26 Apr 2007, Eric W. Biederman wrote:
>
>> If you can make small things go fast, everything speeds up.
>> If you can only make big things go fast only some things speed up.
>> 
>> I want to make small things go fast so everything speeds up.
>
> A reductionist operating system theory? Have you ever heard of emergent 
> properties? A system comprised of pieces can as a whole exibit other 
> characteristics than the basic elements would provide.
>
> I think it is wrong to use the same small things for big things. You 
> would not tow a tanker with your bicycle. Similarly you could use small 
> pages for text files but huge page sizes when you need to transfer 
> gigabytes or terabytes of memory. Its wrong to dictate ones size fits 
> all. (Memories of my relatives in the eastern bloc surface but I better shut
> up.)

Think of it like designing a cpu.  Which would you rather have a
faster clock rate or a new instruction say floating point multiply-accumulate
that means you theoretically double your floating point computation speed 
at a cost of reducing your clock rate?

Up to the limit of it being possible you get more bang out of improving
the little things.  CPUs unfortunately pretty much hit the limit of
improving clock rates.

I don't think we are at the limit of making small things like syscalls,
and pages go fast.

Eric
