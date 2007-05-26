Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbXEZTtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbXEZTtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXEZTtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:49:17 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45795
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXEZTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:49:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 21:49:09 +0200
User-Agent: KMail/1.9.6
Cc: "Benoit Boissinot" <bboissin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705262119.19675.mb@bu3sch.de> <200705262139.54353.uwe.bugla@gmx.de>
In-Reply-To: <200705262139.54353.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705262149.09948.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 21:39:54 Uwe Bugla wrote:
> Am Samstag, 26. Mai 2007 21:19 schrieben Sie:
> > Uwe, please try the following patch:
> >
> > Index: bu3sch-wireless-dev/drivers/net/b44.c
> > ===================================================================
> > --- bu3sch-wireless-dev.orig/drivers/net/b44.c	2007-05-18
> > 18:09:50.000000000 +0200 +++
> > bu3sch-wireless-dev/drivers/net/b44.c	2007-05-26 21:18:28.000000000 +0200
> > @@ -2201,10 +2201,12 @@ static int __devinit b44_init_one(struct
> >  		printk("%2.2x%c", dev->dev_addr[i],
> >  		       i == 5 ? '\n' : ':');
> >
> > +#if 0
> >  	/* Initialize phy */
> >  	spin_lock_irq(&bp->lock);
> >  	b44_chip_reset(bp);
> >  	spin_unlock_irq(&bp->lock);
> > +#endif
> >
> >  	return 0;
> 
> Against what kernel please?
> Just try to be a bit more eloquent, man!

Against a kernel which does not work for you, of course.

Sometimes I wonder... (no better not say that).

-- 
Greetings Michael.
