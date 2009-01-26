Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbZAZIU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbZAZIU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZAZIUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:20:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:33061 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZAZIUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=YdSgzjn7B1u31+KPPDHtoYNVZQY5zid8ltpo68IpPbBQ8x+t1hK7rOmYwUNt0DfvgJ
         +Vbfd4R1uTqPj+CGqB3+0yEda9iW8MAYyaUsMW+0sHJl65KCi5f5qgHnai+p2+xSJvPX
         W8ErPqAOZFuQfmDJ3ecpn1HiXZDwN25MgxluI=
Date: Mon, 26 Jan 2009 08:20:36 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090126082036.GB4183@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120103122.GC9167@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-01-2009 11:31, Evgeniy Polyakov wrote:
...
> I believe approach to meet all our goals is to have own network memory
> allocator, so that each skb could have its payload in the fragments, we
> would not suffer from the heavy fragmentation and power-of-two overhead
> for the larger MTUs, have a reserve for the OOM condition and generally
> do not depend on the main system behaviour.
> 
> I will resurrect to some point my network allocator to check how things
> go in the modern environment, if no one will beat this idea first :)
> 
> 1. Network (tree) allocator
> http://www.ioremap.net/projects/nta

I looked at this a bit, but alas I didn't find much for this Herbert's
idea of payload in fragments/pages. Maybe some kind of API RFC is
needed before this resurrection?

Jarek P.
