Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXIQXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXIQXNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 19:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXIQXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 19:13:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60401
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753478AbXIQXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 19:13:37 -0400
Date: Mon, 17 Sep 2007 16:13:33 -0700 (PDT)
Message-Id: <20070917.161333.38709774.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6.23-rc4-mm1][Bug] kernel BUG at
 include/linux/netdevice.h:339!
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070917141622.330b27b8.akpm@linux-foundation.org>
References: <46EE7026.2070203@linux.vnet.ibm.com>
	<20070917141622.330b27b8.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Sep 2007 14:16:22 -0700

> On Mon, 17 Sep 2007 17:46:38 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Kernel Bug is hit with 2.6.23-rc4-mm1 kernel on ppc64 machine.
> > 
> > kernel BUG at include/linux/netdevice.h:339!
> 
> (please cc netdev@vger.kernel.org on networking-related matters)
> 
> You died here:
> 
> static inline void napi_complete(struct napi_struct *n)
> {
>         BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> 
> The NAPI changes have had a few problems and hopefully things have
> been fixed up since then.  I'll try to get rc6-mm1 out this evening,
> so please retest that?

And if you trigger this still it is absolutely critical that
you tell us what networking device driver you are using at
the time.
