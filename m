Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYG1PpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYG1PpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYG1Po5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:44:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:49484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbYG1Po4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:44:56 -0400
Date: Mon, 28 Jul 2008 08:40:42 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: move ehci reg def
Message-ID: <20080728154042.GC30206@kroah.com>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241727.57692.yhlu.kernel@gmail.com> <200807241757.23441.david-b@pacbell.net> <86802c440807241914o3e09a1a2la1cf9345b4b0e52b@mail.gmail.com> <20080726141813.GG4401@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726141813.GG4401@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 04:18:13PM +0200, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > >> +#include <linux/usb/ehci_def.h>
> > >>
> > >>  /*-------------------------------------------------------------------------*/
> > >>
> > >> +
> > >
> > > Only one blank line needed please.  ;)
> > 
> > thanks.
> > Greg, Do i need to resend ?
> 
> i've fixed it up - see updated patch below.
> 
> Greg, could you please pull this change from the tip/usb-for-greg git 
> tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git usb-for-greg
> 
> so that we can share the commit ID, without you having to carry 
> unrelated x86 fixes? I'll merge this tree too into x86/early-printk.

I only use git for sending stuff to Linus, so that will not really work.

I have no objection for you keeping this in your tree, as that probably
makes it easier.

thanks,

greg k-h
