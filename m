Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDIREc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDIREc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXDIREc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:04:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46225
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbXDIREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:04:31 -0400
Date: Mon, 09 Apr 2007 09:55:23 -0700 (PDT)
Message-Id: <20070409.095523.122833625.davem@davemloft.net>
To: bryan.wu@analog.com
Cc: alan@lxorguk.ukuu.org.uk, waltje@uWalt.NL.Mugnet.ORG, aubreylee@gmail.com,
       netdev@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
From: David Miller <davem@davemloft.net>
In-Reply-To: <1176112223.17975.8.camel@roc-desktop>
References: <6d6a94c50704082001y5c13c865ic3d70217aba7d181@mail.gmail.com>
	<1176112223.17975.8.camel@roc-desktop>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Wu, Bryan" <bryan.wu@analog.com>
Date: Mon, 09 Apr 2007 17:50:22 +0800

> On Mon, 2007-04-09 at 11:01 +0800, Aubrey Li wrote:
> > The option CONFIG_PACKET_MMAP should depend on MMU.
> > 
> > Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
> > ---
> >  net/packet/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/packet/Kconfig b/net/packet/Kconfig
> > index 34ff93f..959c272 100644
> > --- a/net/packet/Kconfig
> > +++ b/net/packet/Kconfig
> > @@ -17,7 +17,7 @@ config PACKET
> > 
> >  config PACKET_MMAP
> >  	bool "Packet socket: mmapped IO"
> > -	depends on PACKET
> > +	depends on PACKET && MMU
> >  	help
> >  	  If you say Y here, the Packet protocol driver will use an IO
> >  	  mechanism that results in faster communication.
> 
> Yeah, this is a bug found on blackfin arch and it is also for other
> NOMMU arch. Is there any solution for this? We think Aubrey's idea
> works.

I will apply this patch.
