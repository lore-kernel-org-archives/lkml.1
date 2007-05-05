Return-Path: <linux-kernel-owner+w=401wt.eu-S934354AbXEESgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354AbXEESgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934326AbXEESgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:36:04 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934324AbXEESgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:36:02 -0400
Date: Sat, 5 May 2007 20:23:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [patch 25/29] xen: Add the Xen virtual network device driver.
Message-ID: <20070505102305.GA12771@gondor.apana.org.au>
References: <20070504232051.411946839@goop.org> <20070504232121.492190579@goop.org> <20070505091624.GA8890@infradead.org> <463C56D3.8060609@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463C56D3.8060609@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 03:05:07AM -0700, Jeremy Fitzhardinge wrote:
>
> Sorry, I forgot about it.  I was waiting to hear back from network
> people about what this is actually for, and whether we really need it. 

We should just change this to use netif_device_attach and
netif_device_detach.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
