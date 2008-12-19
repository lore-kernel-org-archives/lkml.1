Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYLSQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYLSQyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYLSQyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:54:04 -0500
Received: from kroah.org ([198.145.64.141]:37067 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751310AbYLSQyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:54:03 -0500
Date: Fri, 19 Dec 2008 08:52:56 -0800
From: Greg KH <greg@kroah.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: device driver probe return codes
Message-ID: <20081219165256.GD14583@kroah.com>
References: <20081216215331.GH12431@fluff.org.uk> <20081216234128.05a343bb.akpm@linux-foundation.org> <20081219051436.GA29543@kroah.com> <20081219081636.GK12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219081636.GK12431@fluff.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 08:16:36AM +0000, Ben Dooks wrote:
> On Thu, Dec 18, 2008 at 09:14:36PM -0800, Greg KH wrote:
> > On Tue, Dec 16, 2008 at 11:41:28PM -0800, Andrew Morton wrote:
> > > On Tue, 16 Dec 2008 21:53:31 +0000 Ben Dooks <ben-linux@fluff.org> wrote:
> > > 
> > > > I would like some feedback on the following regarding some
> > > > form of standardising return codes from a device driver probe
> > > > to try and stop some basic mistakes.
> > > > 
> > > > This document is not complete, any additions would be welcone.
> > 
> > Hm, shouldn't you have at least copied me on this?
> 
> Sorry, assumed you'd be reading linux-kernel.

I try to, but things get through at at times.  Please always cc: me if
you want me to read it.

> > What is this for?  Each of the different busses treat return codes for
> > their probe functions a bit differently, are you wanting to unify them?
> > And if so, why?
> 
> I was trying to make a guide for people to try and avoid the general
> mistakes such as returning -ENODEV when it clearly isn't the right
> thing to do. There are a number of drivers which return this causing
> confusion as to why devices are not being bound as they neither print
> an error nor cause the driver core to print anything [1].
> 
> The idea is to provide a guide to what error numbers are acceptable
> to return and what the best return code for the common situations
> that drivers tend to do and what to avoid.
> 
> As a note, having looked at the base driver, pci, platform and i2c
> they all pass the error straight back to the core driver probe.

Fair enough, care to respin this and send it out to me for review?

thanks,

greg k-h
