Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbXIXVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbXIXVNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbXIXVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:13:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56031 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756878AbXIXVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:13:32 -0400
Date: Mon, 24 Sep 2007 14:13:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: David Chinner <dgc@sgi.com>, Andrea Arcangeli <andrea@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <Pine.LNX.4.64.0709212044280.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709241411120.30982@schroedinger.engr.sgi.com>
References: <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <1190163523.24970.378.camel@edge.yarra.acx>
 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
 <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random>
 <20070920013821.GR995458@sgi.com> <Pine.LNX.4.64.0709201105350.8626@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0709212044280.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Hugh Dickins wrote:

> I've found some fixes needed on top of your Large Blocksize Support
> patches: I'll send those to you in a moment.  Looks like you didn't
> try much swapping!

yup. Thanks for looking at it.

> 
> I only managed to get ext2 working with larger blocksizes:
> reiserfs -b 8192 wouldn't mount ("reiserfs_fill_super: can not find
> reiserfs on /dev/sdb1"); ext3 gave me mysterious errors ("JBD: tar
> wants too many credits", even after adding JBD patches that you
> turned out to be depending on); and I didn't try ext4 or xfs
> (I'm guessing the latter has been quite well tested ;)

Yes, there were issues with the first releases of the JBD patches. The 
current crop in mm is fine but much of that may have bypassed this list.



