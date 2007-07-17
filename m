Return-Path: <linux-kernel-owner+w=401wt.eu-S934967AbXGQXpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934967AbXGQXpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXGQXpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:45:43 -0400
Received: from ozlabs.org ([203.10.76.45]:53883 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824AbXGQXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:45:42 -0400
Subject: Re: [patch 37/44] xen: add virtual network device driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>, netdev@vger.kernel.org
In-Reply-To: <469CD222.1030202@goop.org>
References: <20070716231536.937393000@xensource.com>
	 <20070716232916.472694000@xensource.com> <20070717094511.795beb69@oldman>
	 <469CD222.1030202@goop.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 09:45:09 +1000
Message-Id: <1184715909.10380.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 07:28 -0700, Jeremy Fitzhardinge wrote:
> Stephen Hemminger wrote:
> >> +struct netfront_info {
> >> +	struct list_head list;
> >> +	struct net_device *netdev;
> >> +
> >> +	struct net_device_stats stats;
> >>     
> >
> > There is now a net_device_stats element inside net_device on
> > 2.6.21 or later.
> >   
> 
> Ah, OK.  Should I just do a s/stats/netdev->stats/?  Is there a generic
> get_stats routine as well?

The default function points to the internal stats...

Cheers,
Rusty.


