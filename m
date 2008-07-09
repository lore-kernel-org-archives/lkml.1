Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYGIVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYGIVNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYGIVNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:13:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:46081 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYGIVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iKIYIkiGLEUZXU2lDG7dikbw3NWi/4wapdRHsXC44xvEzq7w2sYXGLkiq/EorftazA
         sUUYRUqelkzl1+aIu0I0cyVl8UjdJIAYeel9mS+gt3UVywooCr1d7BH02m1fwohKsZcP
         sbBBya76vv7+AMxVtZEGnQWguvQJpWoemxx1E=
Date: Thu, 10 Jul 2008 01:13:11 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: ian <spyro@f2s.com>, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
Message-ID: <20080709211311.GA9726@doriath.ww600.siemens.net>
References: <20080709104916.200210922@fluff.org> <20080709104933.101610936@fluff.org> <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com> <1215603916.3295.57.camel@wirenth> <bc64b4640807090452vc923216gfb14bb2c5974a61@mail.gmail.com> <20080709210314.GF26734@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709210314.GF26734@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 10:03:14PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 09, 2008 at 03:52:08PM +0400, Dmitry wrote:
> > 2008/7/9 ian <spyro@f2s.com>:
> > > On Wed, 2008-07-09 at 15:15 +0400, Dmitry wrote:
> > >> NAK.
> > >> 0) It was discussed yesterday on the list and the decision was to go
> > >> in a different way.
> > >
> > > It was?
> > >
> > > I prefer the wrapped way personally...
> > 
> > In any case IMO it's better to call platform_device_register() rather than
> >  device_initialise()/platform_device_add().
> > 
> > Samuel? Russell?
> 
> WTF???  That's just completely wrong - assuming the internals of how the
> platform device alloc API works...
> 
> What it's clear from my *brief* read of this thread is that the MFD
> support doesn't seem to be ready for mainline yet - there's clearly issues
> here that need further work.
> 
> Given that, and where we are (there's maybe two of *my* days left until
> the merge window opens) I'm *very* tempted to drop the MFD support out
> of my tree for this merge window - which basically means removing
> 5127/1, 5128/1 and 5129/1.

Why? We were talking about improvements, not the current code found in
the referenced patches. They may be not the best ones, but they contain
pretty clean code which works. The only issue with current code is that
tc6393xb depends on some arm-specific defines, so we should either apply
patch submitted today ("tc6393xb irq fixes") or make "depends on ARM".

-- 
With best wishes
Dmitry

