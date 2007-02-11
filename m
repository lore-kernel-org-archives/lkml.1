Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbXBKVMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbXBKVMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 16:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXBKVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 16:12:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:16834 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXBKVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 16:12:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tOs6NqUyIIdzneN+DWa6AGbYtnf1seUuC0TJFVC/KTT5AzQctwS+p1c9jwITpkxhYXr7DLhGJIDBD/n4yGc07scpT2ZPymoty2r1dNv6R2/cs8X8/1vvjY3hTKAjq78p1+zrjpLoofyqAX9D5Irk8M/VmVljJvGzxQx35DCz1A4=
From: Maxim <maximlevitsky@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] [NETDEV] [000]  dmfe : fix bugs and add features
Date: Sun, 11 Feb 2007 23:12:46 +0200
User-Agent: KMail/1.9.6
Cc: Levitsky Maxim <maximlevitsky@yahoo.com>, linux-kernel@vger.kernel.org,
       tori@unhappy.mine.nu, netdev@vger.kernel.org,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
References: <96797.60132.qm@web38511.mail.mud.yahoo.com> <45CCE46E.9010902@garzik.org>
In-Reply-To: <45CCE46E.9010902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702112312.46618.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 23:15:26 Jeff Garzik wrote:
> Levitsky Maxim wrote:
> > Hello,
> >
> > Before some time I decided to fix suspend/resume on my Davicom network
> > card. During development I also fixed couple of bugs and added support
> > for link detection and WOL Note : 2.6.20 already has support for link
> > detection , but it is broken when card has external PHY , like mine.
> >
> > So here it goes:
> >
> > [PATCH] [NET] [001] dmfe : trivial/spelling fixes
> > [PATCH] [NET] [002] dmfe : Fix possible oops
> > [PATCH] [NET] [003] dmfe : fix link detection
> > [PATCH] [NET] [004] dmfe : Add suspend/resume support
> > [PATCH] [NET] [005] dmfe : Add support for wake-on-lan
> >
> >         Maxim Levitsky
> >
> >
> >
> > _________________________________________________________________________
> >___________ Finding fabulous fares is fun.
> > Let Yahoo! FareChase search your favorite travel sites to find flight and
> > hotel bargains. http://farechase.yahoo.com/promo-generic-14795097
> > -
> > To unsubscribe from this list: send the line "unsubscribe netdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> What about the above report?
>
> I would rather fix this first, before applying more patches on top of a
> problematic patch...
>
> > Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
> > support basic carrier detection) breaks networking on my Davicom DM9009.
> > ethtool always reports there is no link.  tcpdump shows incoming
> > packets, but TX is disabled.  Reverting the above patch fixes the
> > problem.
>
> Regards,
>
> 	Jeff
>
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hello,

I agree , I will redo all patches with above commit reverted

Regards , Maxim Levitsky

PS: my mailbox is now maximlevitsky@gmail.com , I took it to use SMTP , 
because it less likely to corrupt patches
