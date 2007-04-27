Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbXD0MBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbXD0MBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbXD0MBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:01:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42680 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755676AbXD0MBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:01:42 -0400
Date: Fri, 27 Apr 2007 05:01:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070427002640.22a71d06.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704270459520.21003@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
 <20070427002640.22a71d06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> On Fri, 27 Apr 2007 00:19:49 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > The page cache handling in the various layers is significantly 
> > simplified which reduces maintenance cost.
> 
> How on earth can the *addition* of variable pagecache size simplify the
> existing code?

Because the page cache code is full of manual shifts and adds. Its a mess. 
Adding appropriate accessors simplifies the code. I took that opportunity 
to slide in an address space parameter into the accessors which allows to 
have sets of accessors for single page size and multi page size 
configurations.

