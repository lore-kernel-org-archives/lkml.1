Return-Path: <linux-kernel-owner+w=401wt.eu-S937386AbXFHBf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937386AbXFHBf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935554AbXFHBfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:35:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37814
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935002AbXFHBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:35:43 -0400
Date: Thu, 07 Jun 2007 18:35:59 -0700 (PDT)
Message-Id: <20070607.183559.67892976.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: akpm@linux-foundation.org, jfannin@gmail.com, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2: Assigning IP address fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070607225452.GA17211@gondor.apana.org.au>
References: <20070607214609.GB8204@nineveh.local>
	<20070607150653.b83bfc0f.akpm@linux-foundation.org>
	<20070607225452.GA17211@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 8 Jun 2007 08:54:52 +1000

> On Thu, Jun 07, 2007 at 03:06:53PM -0700, Andrew Morton wrote:
> >
> > >     I'm not able to bring an ethernet interface down and back up again
> > > with this if avahi-autoipd is installed on my Ubuntu boxes.  I've seen
> > > it on three different computers with different NIC hardware.
> 
> Sorry, it was my patch.  This patch should fix it.
> 
> [IPV4]: Do not remove idev when addresses are cleared
> 
> Now that we create idev before addresses are added, it no longer makes
> sense to remove them when addresses are all deleted.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
