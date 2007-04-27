Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbXD0M62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbXD0M62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXD0M62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:58:28 -0400
Received: from holomorphy.com ([66.93.40.71]:51625 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbXD0M61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:58:27 -0400
Date: Fri, 27 Apr 2007 05:58:43 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427125843.GO19966@holomorphy.com>
References: <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com> <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com> <20070427003216.GM19966@holomorphy.com> <4631CECF.4030301@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4631CECF.4030301@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> I readily concede that seeks are most costly. Yet memory contiguity
>> remains rather influential.
>> Witness the fact that I'm now being called upon a second time to
>> adjust the order in which mm/page_alloc.c returns pages for the
>> sake of implicitly establishing IO contiguity (or otherwise
>> determining why things are coming out backward now).

On Fri, Apr 27, 2007 at 08:22:07PM +1000, Nick Piggin wrote:
> Just a random aside question... doesn't Oracle db do direct IO from
> hugepages?

If and when configured to use direct IO and hugepages, yes. It's also
noteworthy thar Oracle has more code than its database.


-- wli
