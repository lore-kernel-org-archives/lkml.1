Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXD0HfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXD0HfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbXD0HfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:35:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58639 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755452AbXD0HfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:35:20 -0400
Date: Fri, 27 Apr 2007 00:35:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070427002947.ebe7e7ac.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704270031590.5501@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270020280.5501@schroedinger.engr.sgi.com>
 <20070427002947.ebe7e7ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> On Fri, 27 Apr 2007 00:22:26 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > I will submit pieces to mm depending on the 
> > outcome of our discussions.

> There's a ludicrous amount of MM work pending in -mm.  It would probably be
> less work at your end to see what ends up landing in 2.6.22-rc1.

I am aware of that and thats why I kept this against upstream. The need 
right now is for justification and explanation. I had to go 
through a head spinning series of VM layers to get an idea how to do 
this in a clean way and then had to make additional passes to do minimal 
modifications to get this working so that it is testable.
 
Performance tests please...
