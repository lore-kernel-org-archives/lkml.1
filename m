Return-Path: <linux-kernel-owner+w=401wt.eu-S1031437AbXDZSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031437AbXDZSrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031441AbXDZSrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:47:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52011 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031437AbXDZSrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:47:19 -0400
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
Date: Thu, 26 Apr 2007 12:45:57 -0600
In-Reply-To: <Pine.LNX.4.64.0704261103150.3263@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Thu, 26 Apr 2007 11:07:33 -0700
	(PDT)")
Message-ID: <m17irzkm8q.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> On Thu, 26 Apr 2007, Eric W. Biederman wrote:

>> The change the fundamental fragmentation avoidance algorithm of the
>> OS.  Use only one size of page.  That is a huge problem.
>
> No its no problem at all. Its in some peoples head that have never seen it 
> done otherwise. We have another OS here that has dealt with variable sized 
> pages for ages and our people have been shaking their heads for years 
> about these strong opinious that lead us not dealing with the 
> problem.

If you can make small things go fast, everything speeds up.
If you can only make big things go fast only some things speed up.

I want to make small things go fast so everything speeds up.

This isn't whatever OS you are used to dealing with.  Assumptions are
different, and improving streaming read/writes benchmarks are not our
focus.

One of the first rules in storage or OS design is that it better be
reliable, and you patch looks like it will make the VM unreliable.  So
no a design like this will not be agreed to without comment until it
is shown that the VM does not have problems.

Eric
