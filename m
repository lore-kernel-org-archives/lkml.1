Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXKNGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXKNGhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 01:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbXKNGhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 01:37:13 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:27080 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431AbXKNGhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VGu+YH+lTzITSdTPqXh7kmjvRKj2Z2wfZFDEER3YxMdBEwqw5Zgys906JopK6mdCowzq6+7IpBmq7Vn0w8OTt4+BbvEctePyYmx6lFacp6OtxxKaiUUzHr9Mi8qu3XjE13ZINi9G05eS5OGXTsVOPNPNdHx2ZTXHhBJYg3nVtGQ=
Message-ID: <f17812d70711132237g364ce91eq7fe06ab62938019@mail.gmail.com>
Date: Wed, 14 Nov 2007 14:37:06 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <200711131925.11734.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <f17812d70711131657wbdcc089kadb6024a47ad4a3@mail.gmail.com>
	 <f17812d70711131700n74236a8naa6dbfc5cb62e42d@mail.gmail.com>
	 <200711131925.11734.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 14, 2007 11:25 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 13 November 2007, eric miao wrote:
> >
> > Here comes a bunch of patches to illustrate my idea, some are not related to
> > the point I mentioned, and they are not mature for now :-)
> >
> > Subject: [PATCH 1/5] add gpio_is_onchip() for commonly used gpio range checking
>
> I'll send substantive comments later, but meanwhile note
> that the *CURRENT* version was posted last Friday:
>
>   http://marc.info/?l=linux-kernel&m=119463810905330&w=2
>   http://marc.info/?l=linux-kernel&m=119463811005344&w=2
>   http://marc.info/?l=linux-kernel&m=119463811105352&w=2
>
> Plus the appended tweak.  It's more useful to send patches
> against current code, so applying them doesn't provide a
> small avalanche of rejects.  :)
>

Ok, I'll update the patches later.

>
> With respect to this patch adding gpio_is_onchip(), I
> don't see a point.  The "gpio >= chip->base" check
> is basically "are the data structures corrupted?" and
> so it should only be done if "extra_checks" is defined.
> (And IMO, not then ...)  And combining the other two tests
> that way doesn't make anything more clear to me.  That's
> somewhat of a style issue, I guess, unless you're like
> me and don't much trust GCC to avoid extra instructions.
>

just a style issue, moving something commonly done into
a routine, and extra_checks could be put there instead
everywhere for a clean look :-)

> - Dave
>
>



-- 
Cheers
- eric
