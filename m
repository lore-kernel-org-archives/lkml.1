Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXEHGnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXEHGnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXEHGnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:43:24 -0400
Received: from ozlabs.org ([203.10.76.45]:48244 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbXEHGnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:43:19 -0400
Subject: Re: [patch 25/29] xen: Add the Xen virtual network device driver.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <464018F2.7050409@goop.org>
References: <20070504232051.411946839@goop.org>
	 <20070504232121.492190579@goop.org> <20070505091624.GA8890@infradead.org>
	 <463F9608.40803@goop.org> <1178577322.28438.16.camel@localhost.localdomain>
	 <464018F2.7050409@goop.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 16:42:54 +1000
Message-Id: <1178606574.7286.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 23:30 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > Looks good, you can slightly improve it to be the model use of new
> > module_param types by calling your functions param_set_rx_mode and
> > param_get_rx_mode, then simply using "module_param(rx_mode, rx_mode,
> > 0400)"
> >   
> 
> Cute.  I tried it out, but it doesn't yield an obvious improvement:

Of course not, but it's the Right Way!

Thanks,
Rusty.

