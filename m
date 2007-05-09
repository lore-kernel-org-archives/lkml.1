Return-Path: <linux-kernel-owner+w=401wt.eu-S968796AbXEIBhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968796AbXEIBhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935304AbXEIBgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:36:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49173
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935266AbXEIBgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:36:46 -0400
Date: Tue, 08 May 2007 18:36:46 -0700 (PDT)
Message-Id: <20070508.183646.130238577.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jeremy@goop.org, hch@infradead.org, ak@suse.de, akpm@linux-foundation.org,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org,
       shemminge@linux-foundation.org, rusty@rustcorp.com.au,
       Keir.Fraser@cl.cam.ac.uk
Subject: Re: [2/2] [NET] link_watch: Remove delay for up even when we're
 down
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070508121609.GA24763@gondor.apana.org.au>
References: <463F95C3.60407@goop.org>
	<20070508121322.GA21647@gondor.apana.org.au>
	<20070508121609.GA24763@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 8 May 2007 22:16:09 +1000

> [NET]: Remove link_watch delay for up even when we're down
> 
> Currently all link carrier events are delayed by up to a second
> before they're processed to prevent link storms.  This causes
> unnecessary packet loss during that interval.
> 
> In fact, we can achieve the same effect in preventing storms by
> only delaying down events and unnecssary up events.  The latter
> is defined as up events when we're already up.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Also applied, thanks Herbert.
