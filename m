Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXD0Qs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXD0Qs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXD0Qs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:48:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60421 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756074AbXD0Qs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:48:26 -0400
Date: Fri, 27 Apr 2007 09:48:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <4631EBC8.4060003@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704270936220.1534@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au>
 <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com>
 <4631EBC8.4060003@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nick Piggin wrote:

> Linus's favourite jokes about powerpc mmu being crippled forever, aside ;)
> 
> This seems like just speculation. I would not be against something which,
> without, would "cripple" some relevant hardware, but you are just handwaving
> at this point. And you are still ignoring the alternatives.

This crippling also applies to IA64. The crippling is a concern of 
multiple arches and its effects have been well documented. Talk to Peter 
Chubb for example. The requirement is to be able to do I/O to large 
contiguous sections of memory. Your proposals are ignoring the 
requirements.
