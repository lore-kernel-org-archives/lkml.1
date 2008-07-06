Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYGFEOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYGFEOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 00:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYGFEOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 00:14:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53345
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbYGFEOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 00:14:30 -0400
Date: Sat, 05 Jul 2008 21:14:30 -0700 (PDT)
Message-Id: <20080705.211430.83776216.davem@davemloft.net>
To: jeff@garzik.org
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [NET-NEXT PATCH 17/18] net: add netif_napi_del function to
 allow for removal of napistructs
From: David Miller <davem@davemloft.net>
In-Reply-To: <486E1AB1.30902@garzik.org>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
	<20080627180200.22428.70787.stgit@localhost.localdomain>
	<486E1AB1.30902@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Fri, 04 Jul 2008 08:42:25 -0400

> Jeff Kirsher wrote:
> > From: Alexander Duyck <alexander.h.duyck@intel.com>
 ...
> > +/**
> > + *  netif_napi_del - remove a napi context
> > + *  @napi: napi context
> > + *
> > + *  netif_napi_del() removes a napi context from the network device napi list
> > + */
> > +static inline void netif_napi_del(struct napi_struct *napi)
> > +{
> > +#ifdef CONFIG_NETPOLL
> > +	list_del(&napi->dev_list);
> > +#endif
> > +}
> > +
> 
> David - ACK?
> 
> I would prefer to throw this in with the 18-patch igb pile, if that's OK 
> with you.

Fine with me.
