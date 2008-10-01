Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYJAUJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYJAUJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 16:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJAUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 16:08:59 -0400
Received: from kroah.org ([198.145.64.141]:35421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751767AbYJAUI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 16:08:59 -0400
Date: Wed, 1 Oct 2008 13:05:48 -0700
From: Greg KH <greg@kroah.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, TJ <tj@tjworld.net>,
       "Casual J. Programmer" <casualprogrammer@googlemail.com>
Subject: Re: Building two (external) modules from the same sources
Message-ID: <20081001200548.GA30009@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru> <20081001031907.GA19181@kroah.com> <200810011413.17059.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810011413.17059.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 02:13:10PM +0400, Andrey Borzenkov wrote:
> On Wednesday 01 October 2008, Greg KH wrote:
> > On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> > > I have here driver that can be built for two different types of
> > > hardware from basically the same sources (this is port of old Agere
> > > drivers for Hermes-I/Hermes-II chipsets).
> > 
> > Cool, do you have a link to the code, I'd be glad to add it to
> > drivers/staging/ if it's not in a fully-mergable state yet to get wider
> > users for it.
> > 
> 
> You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz
> 
> I doubt that it is suitable for inclusion at current state if ever.
> This is taken directly from Agere 2.4 sources; the only parts that were
> touched are kernel glue and wireless extensions interface.

It is acceptable for inclusion in drivers/staging/ where we can work on
cleaning it up from within the kernel environment, and provide access to
users who are wanting to use these drivers now.

Is it ok if I add it there?  I'll take the above tarball and make up the
proper patch and get it to build.

> And it is not GPL'ed, of course. I attach E-Mail I received a while
> back with answere from Agere legal department.

It's BSD, which is fine, that works with the GPLv2 license of the rest
of the kernel.

> > > Build differs only in one define -DHERMES2 and single file with
> > > different firmware. Unfortunately "if HII" are spread over sources
> > > which makes splitting of sources rather questionable.
> > > 
> > > What is the best way (from kbuild POV) to build two modules - for H-I
> > > and H-II - from the same set of source files?
> > 
> > Not to create two different modules, but rather have one module that
> > works for both pieces of hardware, with dynamic checks for the different
> > portions.
> > 
> 
> I can't; one of the reasons being - I have no idea how to do it. Original
> sources build separate modules for every flavour of driver. It is just that
> I was recently asked about this driver on Zaurus (which happens to use
> Hermes-II); so I had to do something about it.

Hm, I'll look at the code and see if I see anything obvious.

> If someone could offer (link to) hermes-1/2 programming manual ...

That would probably help out a lot :)

thanks,

greg k-h
