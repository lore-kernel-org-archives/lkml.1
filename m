Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXCZVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXCZVGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXCZVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:06:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:16368 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbXCZVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sVV52gwyitzRUbCqJhCaWCKiI2CEsX6gO0dQQlOnYG5gkDtPaKJuut4frhqPY3qhVja/m+36gwARlQNM76kqv5g625tDwfMcbomJiwX4vXDTAA350J6rzSo2LRerpPiM1R6LRVnv+2GCbEzXLAsyQtuCK3sCNb+O4GUQer/oZV8=
Date: Mon, 26 Mar 2007 23:05:58 +0200
To: Brian Braunstein <brian@bristyle.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, vtun@office.satix.net, akpm@osdl.org,
       jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tun/tap: fixed hw address handling
Message-ID: <20070326210558.GC21991@Ahmed>
References: <460632E9.5030508@bristyle.com> <20070326205511.GB21991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326205511.GB21991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 10:55:11PM +0200, ahmed wrote:
> On Sun, Mar 25, 2007 at 01:29:29AM -0700, Brian Braunstein wrote:
> > --- linux-2.6.20.4-ORIG/drivers/net/tun.c	2007-03-23 
> > 12:52:51.000000000 -0700
> > +++ linux-2.6.20.4/drivers/net/tun.c	2007-03-25 00:44:20.000000000 -0700
> > @@ -18,6 +18,10 @@
> > /*
> >  *  Changes:
> >  *
> > + *  Brian Braunstein <linuxkernel@bristyle.com> 2007/03/23
> > + *    Fixed hw address handling.  Now net_device.dev_addr is kept 
> > consistent
> 
> Your mailer still wrap the long lines mistakenly as it did in the first
> version of the patch.
> 

It seems a bug in my mutt mail reader (not a feature, it displays other 
mails long lines without wrapping), sorry.

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

