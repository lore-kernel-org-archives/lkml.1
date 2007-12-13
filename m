Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbXLMBVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbXLMBVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 20:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXLMBVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 20:21:15 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61776 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXLMBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 20:21:14 -0500
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de
In-Reply-To: <200712130148.22727.mb@bu3sch.de>
References: <20071213003028.676998182@mvista.com>
	 <20071213003032.547362071@mvista.com>  <200712130148.22727.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 17:20:00 -0800
Message-Id: <1197508801.22951.40.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 01:48 +0100, Michael Buesch wrote:
> On Wednesday 12 December 2007 09:00:03 Daniel Walker wrote:
> > 
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > 
> > ---
> >  drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c |   30 ++++++++++++-------------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> > 
> > Index: linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> > ===================================================================
> > --- linux-2.6.23.orig/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> > +++ linux-2.6.23/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
> > @@ -43,7 +43,7 @@
> >  
> >  static struct bcm43xx_debugfs fs;
> >  static char really_big_buffer[REALLY_BIG_BUFFER_SIZE];
> > -static DECLARE_MUTEX(big_buffer_sem);
> > +static DEFINE_MUTEX(big_buffer_mutex);
> 
> This driver is scheduled for removal, so I'd not touch it anymore
> to avoid the possibility to introduce a lastminute regression.
> The new drivers (b43 and b43legacy) have this fixed (in a different
> way by completely removing it).

When is the removal scheduled?

Daniel

