Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXDZHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXDZHLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933165AbXDZHLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:11:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42077 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933159AbXDZHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:11:51 -0400
Date: Thu, 26 Apr 2007 00:11:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46304FAF.7020700@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com>
 <46304FAF.7020700@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > Nick, what's the buffer layer? Are you talking about operations
> > based on bufferheads?
> 
> Yeah. Our pgoff_t->sector_t translation.

Sadly the buffers in the buffer layer still assume contiguous memory. You 
would have to add a series of pointers there and then add a layer to 
handle this.

