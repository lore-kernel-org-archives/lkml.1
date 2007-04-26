Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbXDZNuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbXDZNuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbXDZNuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:50:32 -0400
Received: from holomorphy.com ([66.93.40.71]:53007 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXDZNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:50:24 -0400
Date: Thu, 26 Apr 2007 06:50:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426135038.GE19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:
>> OK, I would like to see them. And also discussions of things like why
>> we shouldn't increase PAGE_SIZE instead.

On Thu, Apr 26, 2007 at 12:34:50AM -0700, Christoph Lameter wrote:
> Because 4k is a good page size that is bound to the binary format? Frankly 
> there is no point in having my text files in large page sizes. However, 
> when I read a dvd then I may want to transfer 64k chunks or when use my 
> flash drive I may want to transfer 128k chunks. And yes if a scientific 
> application needs to do data dump then it should be able to use very high 
> page sizes (megabytes, gigabytes) to be able to continue its work while 
> the huge dumps runs at full I/O speed ...

It's possible to divorce PAGE_SIZE from the binary formats, though I
found it difficult to keep up with the update treadmill. Maybe it's
like hch says and I just needed to find more and better API cleanups.
I've only not tried to resurrect it because it's too much for me to do
on my own. I essentially collapsed under the weight of it and my 2.5.x
codebase ended up worse than Katrina as a disaster, which I don't want
to repeat and think collaborators or a different project lead from
myself are needed to avoid that happening again.

It's unclear how much the situation has changed since 32-bit workload
feasibility issues have been relegated to ignorable or deliberate
"f**k 32-bit" status. The effect is doubtless to make it easier, though
to what degree I'm not sure.

Anyway, if that's being kicked around as an alternative, it could be
said that I have some insight into the issues surrounding it.


-- wli
