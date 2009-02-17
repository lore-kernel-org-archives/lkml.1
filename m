Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbZBQPv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbZBQPv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZBQPvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:51:18 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43708 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBQPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:51:18 -0500
Subject: Re: [patch 1/8] slab: introduce kzfree()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.DEB.1.10.0902171007010.19685@qirst.com>
References: <20090216142926.440561506@cmpxchg.org>
	 <20090216144725.572446535@cmpxchg.org> <20090216152751.GA27520@cmpxchg.org>
	 <alpine.DEB.1.10.0902171007010.19685@qirst.com>
Date: Tue, 17 Feb 2009 17:51:16 +0200
Message-Id: <1234885876.11511.3.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 10:08 -0500, Christoph Lameter wrote:
> Why would you want to zero an object on release? Is this for security?
> 
> Please give us some rationale for this. Do we need free on zero now for
> all allocators?

All the call-sites zero out before kfree() for security reasons. But
yeah, we should put that in the patch description as well.

Johannes, I suppose it would make sense to resend the series to Andrew
with all the updates?

			Pekka

