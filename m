Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbXFCP1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbXFCP1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXFCP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:27:46 -0400
Received: from web50102.mail.re2.yahoo.com ([206.190.38.30]:21435 "HELO
	web50102.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752159AbXFCP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:27:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TJLTbeFHPkSrvxE4n9enNNoNSzRnaMSOhSvEFIvf45fIsNEX14q6H3bd5uSnjq2nynLVcb9vzOFSDg9bSuym4Sn4fivmN6NQs86SzNfoa0CDgkPx5iBrbswpKC7jeBRuEu2HI9PEM+URvsVzzmDAcX7Tpxy2fIEuNV4mMPpnDro=;
X-YMail-OSG: d2HKQzQVM1mgk6eAm8uk7iC85ZVzw3xGLi5bQa6RnppBSVPYjaGXMZxXkorGY5pbR5NMpA--
Date: Sun, 3 Jun 2007 08:27:44 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 23/36] drivers edac Lindent amd76x driver
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4662DB9B.400@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <941663.95238.qm@web50102.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Simon Arlott <simon@fire.lp0.eu> wrote:

> On 03/06/07 16:11, Doug Thompson wrote:
> > Run this driver through Lindent for cleanup purposes
> >  amd76x_edac.c |   54
> >  1 file changed, 25 insertions(+), 29 deletions(-)
> > --- linux-2.6.22-rc1.orig/drivers/edac/amd76x_edac.c
> > +++ linux-2.6.22-rc1/drivers/edac/amd76x_edac.c
> > @@ -86,11 +86,9 @@ struct amd76x_dev_info {
> >  
> >  static const struct amd76x_dev_info amd76x_devs[] = {
> >  	[AMD761] = {
> > -		.ctl_name = "AMD761"
> > -	},
> > +		    .ctl_name = "AMD761"},
> >  	[AMD762] = {
> > -		.ctl_name = "AMD762"
> > -	},
> > +		    .ctl_name = "AMD762"},
> >  };
> >  
> 
> You're adding a *lot* of spaces...

Yeah, that is weird - There were 2 tabs and Lindent ADDED 4 spaces on
top of that. I understood that Lindent has problems with 'gotos',
didn't know it had issues like this one.

doug t


> 
> From CodingStyle: "Outside of comments, documentation and except in
> Kconfig, spaces are never used for indentation".
> 
> -- 
> Simon Arlott
> 

