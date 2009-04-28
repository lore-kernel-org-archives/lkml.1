Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZD1XVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZD1XVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZD1XUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:20:55 -0400
Received: from kroah.org ([198.145.64.141]:42901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbZD1XUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:20:54 -0400
Date: Tue, 28 Apr 2009 15:56:34 -0700
From: Greg KH <greg@kroah.com>
To: fmhess@users.sourceforge.net
Cc: Alessio Igor Bogani <abogani@texware.it>, Ian Abbott <abbotti@mev.co.uk>,
       David Schleef <ds@schleef.org>, LKML <linux-kernel@vger.kernel.org>,
       Comedi-ml <comedi_list@googlegroups.com>
Subject: Re: RFC about Comedi on a patch that remove a lot fo code
Message-ID: <20090428225634.GB2076@kroah.com>
References: <63a49ef40904240228g6a28ba8dsf63d2e0bdc6b57d9@mail.gmail.com> <20090424225122.GB3343@kroah.com> <200904261108.09527.fmhess@speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904261108.09527.fmhess@speakeasy.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 11:08:06AM -0400, Frank Mori Hess wrote:
> On Friday 24 April 2009, Greg KH wrote:
> > On Fri, Apr 24, 2009 at 11:28:28AM +0200, Alessio Igor Bogani wrote:
> > > Dear Comedi developers,
> > >
> > > Sorry for my bad english.
> > >
> > > I would be happy to receive your considerations about that patch:
> > >
> > > http://marc.info/?l=linux-next&m=123792129500760&w=2
> > >
> > > I know that some users use Comedi on dual kernel approach systems.
> > > Obviously I don't have any against this but i think that Linux git
> > > tree isn't the right place to support those software (RTAI, Xenomai,
> > > RTLinux and others). Those projects already released patches against
> > > Linux source code so it very easy for them add also patch for Comedi
> > > drivers in the same tarball.
> > >
> > > At the already listed 8 reasons  in that email I want added a ninth
> > > one: 9) Give more chance for interested developers to fix it against
> > > RT_PREEMPT http://marc.info/?l=linux-rt-users&m=124049407712792&w=2
> >
> > I am siding with you, and agree all of the RT stuff should be deleted
> > from the in-kernel comedi code, as there is on in-kernel users of it.
> >
> > Also, the recent Linux RT changes will not need any of these
> > driver-specific changes at all from what I can tell, so they are now
> > obsolete.
> >
> > Frank, unless you have any major objections, I'd like to remove this
> > code.
> 
> I'm okay with it.

Thanks, I've now dropped all of the rt code from the tree.

greg k-h
