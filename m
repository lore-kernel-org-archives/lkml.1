Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZBPBzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZBPBzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZBPBzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:55:35 -0500
Received: from waste.org ([66.93.16.53]:50137 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZBPBzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:55:35 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090216015229.GA13892@gondor.apana.org.au>
References: <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <1234454104.28812.175.camel@penberg-laptop>
	 <20090215133638.5ef517ac.akpm@linux-foundation.org>
	 <1234734194.5669.176.camel@calx>
	 <20090215135555.688ae1a3.akpm@linux-foundation.org>
	 <1234741781.5669.204.camel@calx>
	 <20090215170052.44ee8fd5.akpm@linux-foundation.org>
	 <20090216012110.GA13575@gondor.apana.org.au>
	 <1234747726.5669.215.camel@calx>
	 <20090216015229.GA13892@gondor.apana.org.au>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 19:54:39 -0600
Message-Id: <1234749279.5669.225.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 09:52 +0800, Herbert Xu wrote:
> On Sun, Feb 15, 2009 at 07:28:46PM -0600, Matt Mackall wrote:
> >
> > Yeah. That sucks. We should probably stick in an skb-friendly slab size
> > and see what happens on network benchmarks.
> 
> I don't see how that's going to help since we don't want it to
> cross page boundaries either (having just wasted a day tracking
> down a virtual networking bug because of slab debugging and
> crossing page boundaries).

I'll bite.. what's wrong with page boundaries? Do we play per-SKB TLB
games in virtual network drivers?

-- 
http://selenic.com : development and support for Mercurial and Linux


