Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXFDR6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXFDR6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXFDR6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:58:47 -0400
Received: from holomorphy.com ([66.93.40.71]:47203 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbXFDR6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:58:47 -0400
Date: Mon, 4 Jun 2007 10:59:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070604175924.GE15426@holomorphy.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <20070601204141.f84ad72f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> <20070601213117.1178e8e0.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> <20070601215427.f06d09e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601215427.f06d09e7.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 21:45:15 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
>> That would have to occur with objects that are repeatedly allocated and 
>> then linked toghether etc. Linking typicallty requires a listhead so its 
>> typically difficult to do zero length objects.

On Fri, Jun 01, 2007 at 09:54:27PM -0700, Andrew Morton wrote:
> Well I can't immediately think of a scenario in which it's likely to occur,
> but we're in the position of trying to prove a negative.
> Poke Bill Irwin - he'll think of something ;)

I've yet to see anyone get quite that creative, but I've not gone fishing
for instances of this. I can think of plenty of places where one could do
something like this in practice, but don't care to give anyone any ideas.


-- wli
