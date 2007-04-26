Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXDZSPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXDZSPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXDZSPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:15:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXDZSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:15:06 -0400
Date: Thu, 26 Apr 2007 11:10:05 -0700 (PDT)
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
In-Reply-To: <46305894.3050403@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704261108500.3263@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com>
 <46304FAF.7020700@yahoo.com.au> <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com>
 <46305222.60502@yahoo.com.au> <Pine.LNX.4.64.0704260022570.31003@schroedinger.engr.sgi.com>
 <46305894.3050403@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> Christoph Lameter wrote:
> > On Thu, 26 Apr 2007, Nick Piggin wrote:
> > 
> > 
> > > But I maintain that the end result is better than the fragmentation
> > > based approach. A lot of people don't actually want a bigger page
> > > cache size, because they want efficient internal fragmentation as
> > > well, so your radix-tree based approach isn't really comparable.
> > 
> > 
> > Me? Radix tree based approach? That approach is in the kernel. Do not create
> > a solution where there is no problem. If we do not want to support large
> > blocksizes then lets be honest and say so instead of redefining what a block
> > is. The current approach is fine if one is satisfied with scatter gather and
> > the VM overhead coming with handling these pages. I fail to see what any of
> > what you are proposing would add to that.
> 
> I'm not just making this up. Fragmentation. OK?

Yes you are. If you want to avoid fragmentation by restricting the OS to 
4k alone then the radix tree is sufficient to establish the order of pages 
in a mapping. The only problem is to get an array of pointers to a 
sequence of pages together by reading through the radix tree. I do not 
know what else would be needed.

