Return-Path: <linux-kernel-owner+w=401wt.eu-S1031425AbXDZS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031425AbXDZS2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031429AbXDZS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:28:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54650 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031425AbXDZS2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:28:36 -0400
Date: Thu, 26 Apr 2007 11:28:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426181249.GH2017@kernel.dk>
Message-ID: <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
 <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org>
 <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
 <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org>
 <20070426181249.GH2017@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Jens Axboe wrote:

> The above can be implemented fairly cleanly, and on a need-to-have
> basis. It's not something that'll break drivers.

But its also not going to fix the hacks that we have in the kernel 
to deal with > PAGE_SIZE i/o.

