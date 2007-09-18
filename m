Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbXIRSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbXIRSb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXIRSbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:31:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbXIRSbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:31:48 -0400
Date: Tue, 18 Sep 2007 11:30:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       andrea@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709181116.22573.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Nick Piggin wrote:
> 
> ROFL! Yeah of course, how could I have forgotten about our trusty OOM killer
> as the solution to the fragmentation problem? It would only have been funnier
> if you had said to reboot every so often when memory gets fragmented :)

Can we please stop this *idiotic* thread.

Nick, you and some others seem to be arguing based on a totally flawed 
base, namely:
 - we can guarantee anything at all in the VM
 - we even care about the 16kB blocksize
 - second-class citizenry is "bad"

The fact is, *none* of those things are true. The VM doesn't guarantee 
anything, and is already very much about statistics in many places. You 
seem to be arguing as if Christoph was introducing something new and 
unacceptable, when it's largely just more of the same.

And the fact is, nobody but SGI customers would ever want the 16kB 
blocksize. IOW - NONE OF THIS MATTERS!

Can you guys stop this inane thread already, or at least take it private 
between you guys, instead of forcing everybody else to listen in on your 
flamefest.

			Linus
