Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZBMRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZBMRbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZBMRay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:30:54 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:17309 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751151AbZBMRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:30:53 -0500
Date: Fri, 13 Feb 2009 20:30:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linuxppc-dev@ozlabs.org, Pierre Ossman <drzeus-sdhci@drzeus.cx>,
       Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Liu Dave <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [PATCH 11/13] sdhci: Add quirk for controllers that need IRQ
	re-init after reset
Message-ID: <20090213173047.GA10728@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru> <20090213144738.GK23889@oksana.dev.rtsoft.ru> <200902131647.17728.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200902131647.17728.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 04:47:13PM +0100, Laurent Pinchart wrote:
> Hi Anton,
> 
> On Friday 13 February 2009 15:47:38 Anton Vorontsov wrote:
[...]
> > sdhci_host *host) static void sdhci_reset(struct sdhci_host *host, u8 mask)
> >  {
> >  	unsigned long timeout;
> > +	u32 ier = 0; /* shut up gcc */
> 
> You should use
> 
> 	u32 uninitialized_var(ier);
> 
> instead to avoid generating extra code.

Thanks Laurent, will fix.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
