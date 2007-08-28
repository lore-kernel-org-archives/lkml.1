Return-Path: <linux-kernel-owner+w=401wt.eu-S1759459AbXH1Ssz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbXH1Ssz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXH1Ssp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:48:45 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:48286 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbXH1Sso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:48:44 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Joe Perches <joe@perches.com>
Subject: Re: [NET]: Mark Paul Moore as maintainer of labelled networking.
Date: Tue, 28 Aug 2007 14:48:14 -0400
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <200708280001.l7S01Cxt004543@hera.kernel.org> <20070828130813.E6A1D39C199@ldl.fc.hp.com> <1188319550.6062.31.camel@localhost>
In-Reply-To: <1188319550.6062.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200708281448.15537.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 28 2007 12:45:50 pm Joe Perches wrote:
> On Tue, 2007-08-28 at 08:46 -0400, Paul Moore wrote:
> > If having both a labeled networking and NetLabel maintainer entry is a
> > problem then how about the patch below?
>
> I don't think it is.
>
> > -NETWORKING [LABELED] (NetLabel, CIPSO, Labeled IPsec, SECMARK)
> > +NETWORKING [LABELED] (NetLabel/CIPSO, Labeled IPsec, SECMARK)
> >  P:	Paul Moore
> >  M:	paul.moore@hp.com
> > +W:	http://netlabel.sf.net (NetLabel/CIPSO)
> >  L:	netdev@vger.kernel.org
> >  S:	Maintained
>
> My preference would be for something like:
>
>         NETLABEL and CIPSO
>         P:	Paul Moore
>         M:	paul.moore@hp.com
>         W:	http://netlabel.sf.net
>         L:	netdev@vger.kernel.org
>         S:	Maintained
>         F:	Documentation/netlabel/
>         F:	include/net/netlabel.h
>         F:	net/netlabel/
>
>         Labeled IPsec and SECMARK
>         P:	Paul Moore
>         M:	paul.moore@hp.com
>         L:	netdev@vger.kernel.org
>         S:	Supported
>         F:	include/linux/netfilter/*SECMARK*
>         F:	net/netfilter/*SECMARK*
>
> I would like to add appropriate file patterns for each
> block.  Also, I'm not sure of the Supported/Maintained
> status of each block.

>From the little bit of the discussion that I saw a few weeks ago the idea of 
file patterns in the MAINTAINERS file didn't go over very well.  I still 
don't see the "F" field specified/described at the top of the file.

As long as it is not a problem to have two maintainer entries, I think James' 
patch (what it currently in-tree) is pretty good right now - it fits with the 
rest of the NETWORKING [*] entries and looks correct to me.

> The distinction is supposed to be:
>
>         Supported:	Someone is actually paid to look after this.
>         Maintained:	Someone actually looks after it.
>
> Could you please clarify those for me?

Sure.  HP is my current employer, i.e. they pay me, and both myself and HP 
have pledged to continue supporting NetLabel (see the patchset posting that 
was first accepted into the 2.6.19); I imagine this would fall under 
the "Supported" category as currently stated.  A few days ago I was asked, 
and agreed to, maintain all of the labeled networking code (in addition to 
NetLabel).  While it is extremely likely that HP will support this decision 
and allow me to work on all of the labeled networking infrastructure at work, 
it would be overstepping my role within the company to say that HP is 
pledging support for all of labeled networking.

I think the important thing here is that "someone is looking after this", 
whether or not they are actually paid to do so is not quite as important in 
my mind.  If you feel strongly about the distinction please let me know and I 
will update the status when/if it changes.

-- 
paul moore
linux security @ hp
