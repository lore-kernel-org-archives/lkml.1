Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbYCLEP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbYCLEP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 00:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYCLEPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 00:15:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750835AbYCLEPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 00:15:16 -0400
Date: Tue, 11 Mar 2008 21:14:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
In-Reply-To: <200803121013.20810.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0803112112090.3874@schroedinger.engr.sgi.com>
References: <20080311093144.GB30220@Krystal> <200803112041.09217.nickpiggin@yahoo.com.au>
 <84144f020803110745jcc73368l84e2268b68133520@mail.gmail.com>
 <200803121013.20810.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Nick Piggin wrote:

> The oracle/tpcc one I don't know if it has been fixed?

Ok can someone run this with git head? It could have been there because of 
the 4k alloc forwarding to the page allocator. tbench showed the same 
regression that is why I was fixing the tbench regression.

> > And FWIW, I don't like the patch because it makes the code very hairy.
> > But I don't see why we shouldn't merge SLUB fast-path optimizations if
> > they're clean and you have the numbers to show it's a gain even if
> > there are other remaining regressions.
> 
> I'm talking about this patch specifically though. It makes it much
> harder to work with.

Well the patch would need to be cleaned up a bit first.
