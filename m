Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXDZP6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXDZP6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXDZP6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:58:19 -0400
Received: from holomorphy.com ([66.93.40.71]:36321 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbXDZP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:58:18 -0400
Date: Thu, 26 Apr 2007 08:58:40 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426155840.GU31925@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <20070426135033.GU65285596@melbourne.sgi.com> <4630C776.9000804@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630C776.9000804@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> Or good grounds to increase the sg limit and push for io controller
> manufacturers to do the same. If we have a hack in the kernel that
> mostly works, they won't.

On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> Page colouring was always rejected, and lots of people who knew
> better got upset because it was the only way the hardware would go
> fast...

Yes, stunning wisdom there. Reject the speedups.


On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> You could put it that way. Or that it is wrong because of the
> fragmenatation problem. Realise that it is somewhat fundamental
> considering that it is basically an unsolvable problem with our
> current kernel assumptions of unconstrained kernel allocations and
> a 1:1 kernel mapping.

Depends on what you consider a solution. A broadly used criterion is
that improves performance significantly in important usage cases.


-- wli
