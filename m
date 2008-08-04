Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYHDTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYHDTlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbYHDTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:41:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbYHDTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:41:47 -0400
Date: Mon, 4 Aug 2008 12:37:37 -0700
From: Greg KH <greg@kroah.com>
To: tvrtko.ursulin@sophos.com
Cc: Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] request for comment: generic kernel interface
	for malware vendors
Message-ID: <20080804193737.GB21883@kroah.com>
References: <1217307058.10237.13.camel@perihelion> <20080730111341.BA49F2FE875@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730111341.BA49F2FE875@pmx1.sophos.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:13:36PM +0100, tvrtko.ursulin@sophos.com wrote:
> malware-list-bounces@dmesg.printk.net wrote on 29/07/2008 05:50:58:
> 
> > On Mon, 2008-07-28 at 20:39 -0700, Greg KH wrote:
> > > On Mon, Jul 21, 2008 at 12:18:07AM -0400, Eric Paris wrote:
> > > > 
> > > > This is a request for comment.  This is a first stab and I'm here to
> > > > address all of the concerns that people have.  Please don't hold 
> back,
> > > > I've got thick skin.  BUT, I don't want to hear 'this is how we have
> > > > been doing it, do it that way.'  I want to hear how this won't work 
> for
> > > > your needs (and WHY) or how we can do it better.
> > > > 
> > > > you can find the patches at:
> > > > http://people.redhat.com/~eparis/talpa
> > 
> > Ouch. Adds a bunch of hooks outside of LSM - what's the plan here wrt.
> > LSM, because LKML folks are going to ask :)
> 
> What is the plan with LSM is also a question? Is it gonna stay or be 
> removed?

LSM is staying, no need to remove it.

> Stacking looks like it will never happen and so it really doesn't cut
> it for this kind of use.

Agreed, stacking is probably never going to happen.

thanks,

greg k-h
