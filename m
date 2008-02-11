Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYBKPei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYBKPei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYBKPe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:34:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYBKPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:34:25 -0500
Date: Mon, 11 Feb 2008 07:22:54 -0800
From: Greg KH <greg@kroah.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <osstklei@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH][RESEND] drivers/base: export
	(un)register_memory_notifier
Message-ID: <20080211152254.GC25505@kroah.com>
References: <200802111049.05478.ossthema@de.ibm.com> <1202724743.8276.2.camel@nimitz.home.sr71.net> <200802111147.51225.ossthema@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111147.51225.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:47:50AM +0100, Jan-Bernd Themann wrote:
> On Monday 11 February 2008 11:12, Dave Hansen wrote:
> > On Mon, 2008-02-11 at 10:49 +0100, Jan-Bernd Themann wrote:
> > > are you the right person to address this patch to?
> > 
> > You might want to check the top of the file. ;)
> > 
> > > --- a/drivers/base/memory.c
> > > +++ b/drivers/base/memory.c
> > > @@ -52,11 +52,13 @@ int register_memory_notifier(struct notifier_block *nb)
> > >  {
> > >          return blocking_notifier_chain_register(&memory_chain, nb);
> > >  }
> > > +EXPORT_SYMBOL(register_memory_notifier);
> > >  
> > >  void unregister_memory_notifier(struct notifier_block *nb)
> > >  {
> > >          blocking_notifier_chain_unregister(&memory_chain, nb);
> > >  }
> > > +EXPORT_SYMBOL(unregister_memory_notifier);
> > 
> > Is there a particular reason these can't be GPL?
> > 
> 
> I don't object to make them GPL. Greg, what do you think?

They should be _GPL to match the rest of the driver core.

Care to resend this?

thanks,

greg k-h
