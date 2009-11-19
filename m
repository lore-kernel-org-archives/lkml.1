Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZKSC7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZKSC7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 21:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZKSC7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 21:59:38 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65459 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbZKSC7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 21:59:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YjdbvqpwGt0g4LzVf1L9iaqOik5EjYRi9XY3ibAb6zV5cxkwLIiUeeh5pq0lxRTpB9
         ozTpGq+I4uxvnkHdrHdRns05UfNOMLdcL1o9DOxQuiAAKNP79q9MDnOjoN0CCQdL9zhN
         QW3RpBmIcazDLYegFvtVAvYwlhlY1n7qxnc4Y=
Date: Wed, 18 Nov 2009 18:59:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14626] oops on boot starting udev
Message-ID: <20091119025938.GB20172@core.coreip.homeip.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.fpF.zSdALB@chimera> <20091117011455.GA7977@kroah.com> <20091117020451.GA27967@core.coreip.homeip.net> <1258426743.9883.53.camel@no> <20091117040104.GA5792@core.coreip.homeip.net> <1258430807.12721.12.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258430807.12721.12.camel@no>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 05:06:47AM +0100, Soeren Sonnenburg wrote:
> On Mon, 2009-11-16 at 20:01 -0800, Dmitry Torokhov wrote:
> > On Tue, Nov 17, 2009 at 03:59:03AM +0100, Soeren Sonnenburg wrote:
> > > On Mon, 2009-11-16 at 18:04 -0800, Dmitry Torokhov wrote:
> > > > On Mon, Nov 16, 2009 at 05:14:55PM -0800, Greg KH wrote:
> > > > > On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrote:
> > > > > > This message has been generated automatically as a part of a report
> > > > > > of recent regressions.
> > > > > > 
> > > > > > The following bug entry is on the current list of known regressions
> > > > > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > > > > (either way).
> > > > > > 
> > > > > > 
> > > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
> > > > > > Subject		: oops on boot starting udev
> > > > > > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > > > > > Date		: 2009-11-14 10:16 (3 days old)
> > > > > > References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4
> > > > > 
> > > > > This looks like an input core problem, as the evdev module was just
> > > > > loaded and died.
> > > > > 
> > > > > Any input developers have any ideas?
> > > > > 
> > > > 
> > > > 
> > > > Hmm, evdev does:
> > > > 
> > > > 	dev_set_name(&evdev->dev, "event%d", minor);
> > > > 
> > > > Not sure how it can go wrong...
> > > 
> > > Anything I should/could do to narrow it down a bit (apart from
> > > bisecting?).
> > > 
> > 
> > Umm, I looked through the changes between -rc6 and 7 but nothing jumped
> > out at me... You don't happen to have any local changes in your tree?
> 
> Well only the mouse button #1 emulation - though I don't see what could
> go wrong there.
> 

I have been looking through the changes and I really don't see anything
suspicious. I am also not hittign this oops on any of my boxes. Any
chance you could bisect?

Thanks.

-- 
Dmitry
