Return-Path: <linux-kernel-owner+w=401wt.eu-S1751044AbXDZSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044AbXDZSQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXDZSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:16:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53297 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbXDZSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:16:18 -0400
Date: Thu, 26 Apr 2007 11:16:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426145310.GH19966@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704261115400.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
 <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
 <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, William Lee Irwin III wrote:

> On Thu, Apr 26, 2007 at 05:42:17PM +1000, Nick Piggin wrote:
> > I don't think that it is solved, and I think the heuristics that are
> > there would be put under more stress if they become widely used. And
> > it isn't only about whether we can get the page or not, but also about
> > the cost. Look up Linus's arguments about page colouring, which are
> > similar and  I also think are pretty valid.
> 
> Perhaps broader exposure would help demonstrate their efficacy, or
> otherwise discover what deficits need to be addressed.

It would help if developers would once in a while look at how other 
operating systems handle this. They have supported such features for a 
long time.

