Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbYBKKsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbYBKKsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYBKKr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:47:57 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:28535 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYBKKrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:47:55 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH][RESEND] drivers/base: export (un)register_memory_notifier
Date: Mon, 11 Feb 2008 11:47:50 +0100
User-Agent: KMail/1.8.2
Cc: Greg KH <greg@kroah.com>, Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <osstklei@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>
References: <200802111049.05478.ossthema@de.ibm.com> <1202724743.8276.2.camel@nimitz.home.sr71.net>
In-Reply-To: <1202724743.8276.2.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111147.51225.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 11:12, Dave Hansen wrote:
> On Mon, 2008-02-11 at 10:49 +0100, Jan-Bernd Themann wrote:
> > are you the right person to address this patch to?
> 
> You might want to check the top of the file. ;)
> 
> > --- a/drivers/base/memory.c
> > +++ b/drivers/base/memory.c
> > @@ -52,11 +52,13 @@ int register_memory_notifier(struct notifier_block *nb)
> >  {
> >          return blocking_notifier_chain_register(&memory_chain, nb);
> >  }
> > +EXPORT_SYMBOL(register_memory_notifier);
> >  
> >  void unregister_memory_notifier(struct notifier_block *nb)
> >  {
> >          blocking_notifier_chain_unregister(&memory_chain, nb);
> >  }
> > +EXPORT_SYMBOL(unregister_memory_notifier);
> 
> Is there a particular reason these can't be GPL?
> 

I don't object to make them GPL. Greg, what do you think?

Regards,
Jan-Bernd

