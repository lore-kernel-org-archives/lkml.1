Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXDZHLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXDZHLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933332AbXDZHLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:11:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42040 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933331AbXDZHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:11:02 -0400
Date: Thu, 26 Apr 2007 00:10:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46304D50.1040706@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
 <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au>
 <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
 <46304D50.1040706@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > Right and we need to create series of other approaches that we then label
> > "non-hack" to replace it. 
> 
> I don't understand? We're talking about several utterly different designs
> to approach these problems. You don't agree that one might be better than
> another?

What I seeing is a series of approaches being put into the kernel to 
address this issue. We already have the lumpy reclaim there. Then we talk 
about other fixed to basic page handling in the kernel to make it better.
Now you want yet another fs layer. All of that could be taken care of by
a defrag approach with larger pages. This has been done a number of times 
before and actually the large page approach is a textbook example on how 
to improve performance. It goes waaaay back.

> > The code paths can stay the same. You can switch CONFIG_LARGE pages off
> > if you do not want it and it is as it was.
> 
> That isn't a good reason to merge something. If you don't have numbers then
> that just seems incredible.

Dont worry you will get numbers... Just did not have time to fix the bug 
in this one since I had to take care of something else.
