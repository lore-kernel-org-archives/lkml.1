Return-Path: <linux-kernel-owner+w=401wt.eu-S1030974AbXD1Dta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030974AbXD1Dta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030984AbXD1Dta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:49:30 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38817 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030974AbXD1Dt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:49:29 -0400
Date: Fri, 27 Apr 2007 20:49:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070428031739.GK32602149@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0704272047550.7119@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
 <20070427002640.22a71d06.akpm@linux-foundation.org>
 <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com>
 <20070427121108.9ee05710.akpm@linux-foundation.org>
 <20070428031739.GK32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, David Chinner wrote:

> > 1-disk and 2-disk read throughput fell by an improbable amount, which makes
> > me cautious about the other numbers.
> 
> For read, yes, and it's because something is going wrong with the
> I/O size - it looks like readahead thrashing of some kind even
> with 4k pages tests.

Yup. I seem to have a problem in that area with my patches. Somehow the
nr of page is shifted by page order. I do not completely understand what 
is going on there yet.

