Return-Path: <linux-kernel-owner+w=401wt.eu-S1751072AbXC1Il4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072AbXC1Il4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXC1Il4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:41:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3723 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751072AbXC1Ilz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:41:55 -0400
Date: Wed, 28 Mar 2007 08:41:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/8] Processor degredation support.
Message-ID: <20070328084145.GA3988@ucw.cz>
References: <20070326212459.711271424@de.ibm.com> <20070326212634.931820139@de.ibm.com> <20070327213529.GB5842@ucw.cz> <20070328065443.GA8146@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328065443.GA8146@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-03-28 08:54:43, Heiko Carstens wrote:
> > > +++ linux-2.6/drivers/s390/char/sclp_confmgm.c
> > 
> > Can we get less cyptic name?
> 
> Would you like to see sclp_configuration_management.c?

No, but maybe sclp_manager.c or sclp_config.c?


> > > +static void sclp_conf_receiver_fn(struct evbuf_header *evbuf)
> > > +{
> > > +	struct conf_mgm_data *cdata;
> > > +
> > > +	cdata = (struct conf_mgm_data *)(evbuf + 1);
> > > +	if (cdata->ev_qualifier == EV_QUAL_CAP_CHANGE)
> > > +		/* Will be parsed. Don't change. */
> > > +		printk(KERN_WARNING "sclp: CPU capability changed.\n");
> > > +}
> > 
> > What's that? I do not think printk provides guaranteed delivery.
> 
> True. But which generic interface is currently used to notify user space
> of state changes? Maybe a uevent for the cpu device..

Maybe.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
