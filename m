Return-Path: <linux-kernel-owner+w=401wt.eu-S1763630AbXH3XUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763630AbXH3XUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXH3XUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:20:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43440 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXH3XUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:20:22 -0400
Date: Fri, 31 Aug 2007 00:20:20 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Christoph Hellwig <hch@infradead.org>
cc: Kristian H?gsberg <krh@redhat.com>, linux-kernel@vger.kernel.org,
       m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/23] drm: introduce drm_zalloc
In-Reply-To: <20070830162400.GA12108@infradead.org>
Message-ID: <Pine.LNX.4.64.0708310013460.23110@skynet.skynet.ie>
References: <20070827205750.514001000@tuxland.pl> <20070828200821.GA7998@infradead.org>
 <Pine.LNX.4.64.0708282149180.15296@skynet.skynet.ie>
 <1188490832.7269.6.camel@hinata.boston.redhat.com> <20070830162400.GA12108@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Note the slab has a memory tracking feature that accounts memory to
> callers of the allocator.  IF that's not enough for you please help
> improving the common code instead of inventing your own.

Christoph that code was written over 6-7 years ago, feel free to provide a 
patch for it to use the slab allocator, we only turn this code on though 
when developing new drivers, I don't think it ever gets used outside of 
that.. we don't need the overhead of the memory tracking in normal use..

Please stop implying that all the code in the drm is magically new and 
that we should be reusing kernel infrastructure that wasn't even written 
when the code first appeared.. or provide patches...

Dave.
