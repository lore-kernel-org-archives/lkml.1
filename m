Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXEBEXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXEBEXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXEBEXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:23:17 -0400
Received: from ozlabs.org ([203.10.76.45]:52596 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbXEBEXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:23:16 -0400
Subject: Re: netfront for review
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <20070502035127.GA28090@gondor.apana.org.au>
References: <4637D672.5030706@goop.org>
	 <1178077033.28659.173.camel@localhost.localdomain>
	 <20070502035127.GA28090@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 02 May 2007 14:23:02 +1000
Message-Id: <1178079783.28659.183.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 13:51 +1000, Herbert Xu wrote:
> On Wed, May 02, 2007 at 01:37:13PM +1000, Rusty Russell wrote:
> >
> > > +static int xennet_change_mtu(struct net_device *dev, int mtu)
> > > +{
> > > +	int max = xennet_can_sg(dev) ? 65535 - ETH_HLEN : ETH_DATA_LEN;
> >
> > This seems odd to me: just because a device does TSO should we really
> > allow huge mtu settings?  Herbert?
> 
> Actually this has nothing to do with TSO/GSO.  This driver inherently
> supports arbitrary MTUs that's only limited by our network stack.  If
> the physical network device can't handle it you'll just get an ICMP
> error back or fragmentation.

Oops, I misread "xennet_can_sg" as a test for GSO.

Thanks for the clarification,
Rusty.

