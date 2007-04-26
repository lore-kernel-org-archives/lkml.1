Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXDZHew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXDZHew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbXDZHew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:34:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933153AbXDZHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:34:51 -0400
Date: Thu, 26 Apr 2007 00:34:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46305327.2000206@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
 <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au>
 <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
 <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
 <46305327.2000206@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> No I don't want to add another fs layer.

Well maybe you could explain what you want. Preferably without redefining 
the established terms?

> I still don't think anti fragmentation or defragmentation are a good
> approach, when you consider the alternatives.

I have not heard of any alternatives in this discussion here. Just the old 
line of lets tune the VM here and there and hope it lasts a while longer.

> OK, I would like to see them. And also discussions of things like why
> we shouldn't increase PAGE_SIZE instead.

Because 4k is a good page size that is bound to the binary format? Frankly 
there is no point in having my text files in large page sizes. However, 
when I read a dvd then I may want to transfer 64k chunks or when use my 
flash drive I may want to transfer 128k chunks. And yes if a scientific 
application needs to do data dump then it should be able to use very high 
page sizes (megabytes, gigabytes) to be able to continue its work while 
the huge dumps runs at full I/O speed ...


