Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZAWJEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZAWJEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZAWJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:04:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45174 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZAWJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:04:26 -0500
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: cl@linux-foundation.org, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <200901231952.53961.nickpiggin@yahoo.com.au>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901231952.53961.nickpiggin@yahoo.com.au>
Date: Fri, 23 Jan 2009 11:04:24 +0200
Message-Id: <1232701464.6094.21.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2009 19:43:20 Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >
> > This patch reverts page allocator pass-through logic from the SLUB
> > allocator.
> >
> > Commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through
> > of page size or higher kmalloc requests")

On Fri, 2009-01-23 at 19:52 +1100, Nick Piggin wrote:
> Hmm, it lists quite a number of advantages that I guess are being
> reverted too? What was the test case(s) that prompted this commit
> in the first place? Better ensure it doesn't slow down...

Oh, I see I forgot to put an RFC in the patch subject line. I'm not
going to merge this just yet.

Christoph, suggestions on the test case?

