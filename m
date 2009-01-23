Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZAWPmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZAWPmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZAWPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:42:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42374 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZAWPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:42:22 -0500
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <alpine.DEB.1.10.0901231022490.21692@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901231952.53961.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901230955470.13690@qirst.com>
	 <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com>
	 <alpine.DEB.1.10.0901231022490.21692@qirst.com>
Date: Fri, 23 Jan 2009 17:42:20 +0200
Message-Id: <1232725340.6094.95.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 5:03 PM, Christoph Lameter
> > <cl@linux-foundation.org> wrote:
> > > It seems that we currently need the slab allocators to compensate for the
> > > performance problems in the page allocator for these higher order allocs.
> > > I'd rather have the page allocator fixed but things are as they are.

On Fri, 23 Jan 2009, Pekka Enberg wrote:
> > So, is that an ACK or a NAK for the patch?-)

On Fri, 2009-01-23 at 10:25 -0500, Christoph Lameter wrote:
> Doesnt that break down Nick's order-0 dominates-the-world scheme break
> down? One of the reasons for doing this was to get the page allocator
> performance issues exposed and addressed.
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>

Thanks. I'm putting this in linux-next now. Lets see what breaks.

		Pekka

