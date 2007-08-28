Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXH1Svv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXH1Svv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXH1Svo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:51:44 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:16088 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbXH1Svn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=jO3vQ79zN4qL7UvuYQmZW27NotSSri8RAc80Nz2nvbmkkfY8qMFasaaG3OZSDFLpvLjdXxgxSD0XO4MilCOVESPWqab1I4iXu4uVbeAjVVUx0Q6G1XVVShpvqelf+6qop2uXjXo9JuIXI5aOANaqtMRc4AtOWibKON6hsOP+qHo=
Date: Tue, 28 Aug 2007 22:51:29 +0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ok to kill "ether=" kernel parm?
Message-ID: <20070828185129.GA2148@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0708280307350.3354@localhost.localdomain> <46D45111.2040600@zytor.com> <Pine.LNX.4.64.0708281300030.18151@localhost.localdomain> <46D45A02.6010306@zytor.com> <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708281347390.20783@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 01:58:05PM -0400, Robert P. J. Day wrote:
> On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> 
> > Robert P. J. Day wrote:
> > > On Tue, 28 Aug 2007, H. Peter Anvin wrote:
> > >
> > >> Robert P. J. Day wrote:
> > >>>   given that "ether=" has been officially obsolete since 2.6.18
> > >>> (replaced by "netdev="), is there any reason to keep it around?
> > >>> or can it be blasted?
> > >> That sounds like way too short of a timeline for breaking people's
> > >> working boot setup.  For a lot of people, 2.6.18->current is going
> > >> to be a single step.
> > >
> > > actually, now that i look more closely at the code browser at
> > > lxr.linux.no, "ether=" has been listed as "obsolete" since *at least*
> > > 2.6.10.  not to sound unsympathetic but anyone who tries to jump from
> > > 2.6.10 to 2.6.24 in one step deserves what they get.  :-)
> > >
> > > ok, that was cruel, but you see my point, right?
> >
> > Yes, and I think it's quite pointless.
> >
> > The thing is, people's boot setups have probably been that way since
> > *long* before 2.6.9.  They continue to work, as they should, so they
> > aren't changed.  This is why we very rarely break boot interfaces
> > (and this is a user-visible interface you're talking about); we're
> > still supporting interfaces that have been obsolete *SINCE BEFORE
> > 1.0 WAS RELEASED.*
> >
> > What's the upside of changing?  What's the downside?  The upside is
> > so infinitesimal that that leaving "ether=" in indefinitely seems
> > like a good move to me.
> 
> i've never found these "well, it's not hurting anything" arguments
> terribly compelling.

And? AFAICS, handler doesn't even print boot time warning message that
ether= is obsoleted.
