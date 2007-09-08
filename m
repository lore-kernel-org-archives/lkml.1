Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbXIHAiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbXIHAiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 20:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXIHAiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 20:38:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53982 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbXIHAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 20:38:07 -0400
Subject: Re: 2.6.23-rc4-mm1 myri10ge module link error on x86_64
From: Daniel Walker <dwalker@mvista.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, help@myri.com
In-Reply-To: <46E1E5E7.4080508@garzik.org>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <20070906193751.GA4518@Krystal>
	 <20070906.134038.85411315.davem@davemloft.net>
	 <20070906.134831.39160997.davem@davemloft.net>
	 <46E1E5E7.4080508@garzik.org>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 17:25:37 -0700
Message-Id: <1189211137.9688.21.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 19:59 -0400, Jeff Garzik wrote:

> > 
> > commit 9fd380e892e078b582920325357292c07eeeecc9
> > Author: David S. Miller <davem@kimchee.(none)>
> > Date:   Thu Sep 6 21:44:36 2007 +0100
> > 
> >     [MYRI10GE]: Need to select INET_LRO.
> >     
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index b92b7dc..7d1a84e 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -2496,6 +2496,7 @@ config MYRI10GE
> >  	depends on PCI
> >  	select FW_LOADER
> >  	select CRC32
> > +	select INET_LRO

Didn't catch this one .. Guess -mm a little out of date..

Daniel

