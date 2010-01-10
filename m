Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258Ab0AJNtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0AJNtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 08:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211Ab0AJNtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 08:49:55 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:61182 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0AJNty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 08:49:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sNeQXIVa+xmdpiCV483LwUsF5vNvFGLcpTBWXw6MhfGVusEaPIAn3wQPye4ULWgAKv
         HEm8llaZ7A7P1wNb2J8s2Vy+ByTQsdxde0266vT3ZWJzA8QUmxRbOa2OTR3/Ovw3gDhE
         wleou36Cs5teO1wVgA5v+ccP4ooBTKcUgszyI=
Date: Sun, 10 Jan 2010 16:49:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>, Brian Gerst <brgerst@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100110134951.GD5189@lenovo>
References: <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de> <20100108215039.GD4967@lenovo> <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com> <20100110080940.GB5189@lenovo> <1263128343.2393.45.camel@cthulhu.hellion.org.uk> <20100110133628.GC5189@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110133628.GC5189@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 04:36:28PM +0300, Cyrill Gorcunov wrote:
...
> > 
> > With just the CS RPL fix below I see a GPF at kernel_thread_helper with
> > SS=3 (hence my hypothesis about NULL selectors and non-zero RPL above).
> > With both the SS and CS fixes things work fine.
> 
> any of CS,SS loaded with NULL descriptor should lead to #GP
> 

though SS with RPL=0 is allowed to be NULL descriptor in 64bit mode

> > 
> > Ian.
> > 
> > --- 
> > Subject: xen: 64 bit kernel RPL should be 0.
> > 
> ...
> 
> Good catch Ian! I've noted that Xen use it's own get_kernel_rpl
> while discussing this problem in a chat. But I must admit *I simply don't know*
> what Xen does, or how it works internally (neither I have will to learn it at
> moment :)
> 
> That said -- I'm happy if yor patch fixes problem (and it looks that
> get_kernel_rpl is guilty here indeed).
> 
> 	-- Cyrill

	-- Cyrill
