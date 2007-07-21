Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbXGUDsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbXGUDsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXGUDsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:48:23 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41455
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXGUDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:48:22 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Fri, 20 Jul 2007 23:48:14 -0400
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <20070720095401.68e9ce03@gondolin.boeblingen.de.ibm.com> <20070720080936.GA22047@kroah.com>
In-Reply-To: <20070720080936.GA22047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202348.14759.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 4:09:36 am Greg KH wrote:
> On Fri, Jul 20, 2007 at 09:54:01AM +0200, Cornelia Huck wrote:
> > On Fri, 20 Jul 2007 00:00:01 -0700,
> >
> > Greg KH <greg@kroah.com> wrote:
> > > > I don't insist on it, mknod insists on it.  You cannot mknod a dev
> > > > node without specifying block or char.
> > > >
> > > > You're saying that sysfs should provide major and minor numbers
> > > > without anywhere specifying "char" or "block", meaning the major and
> > > > minor numbers cannot be _used_.  I am insisting on getting the third
> > > > piece of information without which "major" and "minor" are useless.
> > > >
> > > > I asked very specifically about this at OLS, several times.  What
> > > > you're telling me now seems to contradict what you told me then.
> > >
> > > Here's the rule:
> > > 	If the SUBSYSTEM is "block", it's a block device.  Otherwise
> > > 	it's a char device.
> >
> > That's actually quite confusing to the casual reader, since:
> > > But also realize that the majority of events you will get have nothing
> > > to do with device nodes.  I think you are forgetting this fact.
> >
> > So the rule should be:
> > 	If the SUBSYSTEM is "block" (implying major/minor are provided),
> > 	it's a block device.
> > 	If the SUBSYSTEM is not "block", and major/minor are provided,
> > 	it's a char device.
> > 	If major/minor are not provided, the event/device is not
> > 	relevant to device node creation.
>
> Yes, that is much more descriptive, thanks.

agreed, thanks.

I'll try to post an updated version of my hotplug documentation later tonight.  
(Just a _touch_ jetlagged at the moment, though.  It may only be 9:47 
california time, but it's 11:47 on the east cost.  I think.)

> greg k-h

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
