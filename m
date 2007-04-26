Return-Path: <linux-kernel-owner+w=401wt.eu-S1031427AbXDZSWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031427AbXDZSWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031428AbXDZSWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:22:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54314 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031427AbXDZSWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:22:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
	<46303A98.9000605@yahoo.com.au>
	<Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
	<46304C74.9040304@yahoo.com.au>
	<Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
	<46305177.7060102@yahoo.com.au>
	<Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
	<463057D9.9030804@yahoo.com.au>
	<20070426145310.GH19966@holomorphy.com>
Date: Thu, 26 Apr 2007 12:21:24 -0600
In-Reply-To: <20070426145310.GH19966@holomorphy.com> (William Lee Irwin, III's
	message of "Thu, 26 Apr 2007 07:53:10 -0700")
Message-ID: <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III <wli@holomorphy.com> writes:

> On Thu, Apr 26, 2007 at 05:42:17PM +1000, Nick Piggin wrote:
>> Actually, I don't know why people are so excited about being able to
>> use higher order allocations (I would rather be more excited about
>> never having to use them). But for those few places that really need
>> it, I'd rather see them use a virtually mapped kernel with proper
>> defragmentation rather than putting hacks all through the core code.
>
> In memory as on disk, contiguity matters a lot for performance.

Not nearly so much though.  In memory you don't have seeks to avoid.
On disks avoiding seeks is everything.

Eric
