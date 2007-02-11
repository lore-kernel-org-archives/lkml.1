Return-Path: <linux-kernel-owner+w=401wt.eu-S1750785AbXBKVFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750785AbXBKVFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXBKVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:05:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:10723 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXBKVFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=n0urpFFzAzHwPgJf6sfZoji/bQGB6JGnFhULv8fmw1QZR4RhPHxfSygY714ibP2G6td21OSinvbxHd9OcJCkOXzbnTBMqFUDPTqWG3vGNMQFd0ZP0iz2PoVl1l2TOD7OMYPwMqo4IqWaluhXYtxq4iJbErqzD5YLHttCwKQDXto=
From: Maxim <maximlevitsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, pavel@ucw.cz
Subject: Re: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support
Date: Sun, 11 Feb 2007 23:05:34 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tori@unhappy.mine.nu, netdev@vger.kernel.org
References: <549393.8054.qm@web38506.mail.mud.yahoo.com> <20070209205451.GA3949@ucw.cz>
In-Reply-To: <20070209205451.GA3949@ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <45cf8524.034e66ed.1dc4.638d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 22:54:52 Pavel Machek wrote:
> Hi!
>
> > From: Maxim Levitsky <maximlevitsky@yahoo.com>
> > Subject: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support
> >
> > Adds support for suspend/resume
>
> Patch looks ok, but your mailer damaged it heavily.
>
> > --- linux-2.6.20-mod/drivers/net/tulip/dmfe.c   2007-02-07
> > 18:46:13.000000000 +0200 +++
> > linux-2.6.20-test/drivers/net/tulip/dmfe.c  2007-02-07 18:50:52.000000000
> > +0200 @@ -55,9 +55,6 @@
> >  
> >      TODO
> >  
> > -    Implement pci_driver::suspend() and pci_driver::resume()
> > -    power management methods.
> > -
> >      Check on 64 bit boxes.
> >      Check and fix on big endian boxes.
> >  
> > @@ -2027,11 +2024,59 @@ static struct pci_device_id dmfe_pci_tbl
> >  MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
> >  
> >  
> > +
> > +static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
> > +{
>
> 							Pavel


Hi , thanks for reply , I will send them again, and this time I will check 
that mailer doesn't mess with patches.

I fixed word wrap problem.

I also want to note that my address is now maximlevitsky@gmail.com , the 
address I took recently because yahoo is only aviable via webmail
and it is not good for patches.

Thanks for reply, 

regards , Maxim Levitsky

