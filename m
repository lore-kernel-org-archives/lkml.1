Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbXFQPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbXFQPdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXFQPd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:33:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:41240 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXFQPd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e0IzsXdXdpAZUHUbwYztlkgkA7B1ELyI6f40jysqM7WdPMj0DKnD91le8qObdtn+VXTdKqKfU7c7U5H4lBagSaZAdzk/5OMQrkU4nnputVMBPAqE/otXinko9zN27pJtK/y4c53GN5kcYHAw86Td4sFTYLd4Xk63rBP3HZhKyTs=
Message-ID: <6bffcb0e0706170833x36aa33a3x5ff81ba5a112528f@mail.gmail.com>
Date: Sun, 17 Jun 2007 17:33:27 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: git-current: slub breaks s2ram with fglrx...
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Stefan Seyfried" <seife@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1182093905.3841.23.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1182073786.3841.11.camel@localhost>
	 <200706171304.46181.rjw@sisk.pl> <1182093905.3841.23.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

On 17/06/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Sun, 2007-06-17 at 13:04 +0200, Rafael J. Wysocki wrote:
> > On Sunday, 17 June 2007 11:49, Soeren Sonnenburg wrote:
> > > OK,
> [...]
> > > slab & fglrx works
> > > slub & console works
> > > slub & X11+fglrx creates hangs on suspend (black screen - no further
> > > idea ...)
> > >
> > > It should be noted that withouth the proprietary  fglrx.ko module loaded
> > > the machine just reboots on s2ram (though IIRC without fglrx.ko loaded
> > > it worked with 2.6.19 or so...)
> > >
> > > Is this a kernel thing or yet another bug in fglrx ?
> >
> > I have no idea.
> >
> > I guess we should let Christoph know about it (CC added), but I'm afraid
> > we won't be able to figure out what's wrong without access to the driver's
> > source code ...
>
> I have one question: What if I don't load fglrx.ko but still use the
> proprietary binary driver for xorg.

AFAIK it will not work.

> Shouldn't s2ram work with that ? And
> if not is this considered a kernel bug or still a ati-binary driver
> bug ?
>
> Soeren
> --
> Sometimes, there's a moment as you're waking, when you become aware of
> the real world around you, but you're still dreaming.
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
