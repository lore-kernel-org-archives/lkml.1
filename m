Return-Path: <linux-kernel-owner+w=401wt.eu-S1756344AbYFIXJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbYFIXJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFIXJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:09:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYFIXJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:09:04 -0400
Date: Mon, 9 Jun 2008 15:58:43 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-ID: <20080609225843.GA23391@kroah.com>
References: <200806061922.m56JMJuq025990@hera.kernel.org> <20080606233037.GA8548@kroah.com> <20080606230239.c1a8c002.akpm@linux-foundation.org> <20080607173436.GA17603@kroah.com> <20080609083301.GA6701@shadowen.org> <1213009781.32207.615.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213009781.32207.615.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 12:09:41PM +0100, David Woodhouse wrote:
> On Mon, 2008-06-09 at 09:33 +0100, Andy Whitcroft wrote:
> > The issue I have is I have a comprehensive test suite which is kept in
> > lock step with checkpatch itself, all in my own tree.  Now that is
> > just noise for mainline.  What I want to be able to do is keep that in
> > lock step with developments in my tree, but not merge it upstream.  So
> > far I've not found a workable solution with git for that.
> 
> Why not make a tree which automatically tracks Linus' tree but only
> includes checkpatch.pl. Then pull from that into your own tree before
> you push your changes back.

Or just use quilt.  Or git.  Or something that takes into account that
your file will change in the mainline tree.

Keeping code outside the kernel tree and then blindly doing a diff to
generate a patch for submission is never considered a good idea, and
causes real problems, as seen here.

thanks,

greg k-h
