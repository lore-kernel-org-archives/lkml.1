Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbYFKIuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbYFKIuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYFKIuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:50:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4082 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYFKIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:50:04 -0400
Date: Wed, 11 Jun 2008 09:49:53 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Greg KH <greg@kroah.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-ID: <20080611084953.GG6701@shadowen.org>
References: <200806061922.m56JMJuq025990@hera.kernel.org> <20080606233037.GA8548@kroah.com> <20080606230239.c1a8c002.akpm@linux-foundation.org> <20080607173436.GA17603@kroah.com> <20080609083301.GA6701@shadowen.org> <1213009781.32207.615.camel@pmac.infradead.org> <20080609225843.GA23391@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609225843.GA23391@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 03:58:43PM -0700, Greg KH wrote:
> On Mon, Jun 09, 2008 at 12:09:41PM +0100, David Woodhouse wrote:
> > On Mon, 2008-06-09 at 09:33 +0100, Andy Whitcroft wrote:
> > > The issue I have is I have a comprehensive test suite which is kept in
> > > lock step with checkpatch itself, all in my own tree.  Now that is
> > > just noise for mainline.  What I want to be able to do is keep that in
> > > lock step with developments in my tree, but not merge it upstream.  So
> > > far I've not found a workable solution with git for that.
> > 
> > Why not make a tree which automatically tracks Linus' tree but only
> > includes checkpatch.pl. Then pull from that into your own tree before
> > you push your changes back.
> 
> Or just use quilt.  Or git.  Or something that takes into account that
> your file will change in the mainline tree.
> 
> Keeping code outside the kernel tree and then blindly doing a diff to
> generate a patch for submission is never considered a good idea, and
> causes real problems, as seen here.

Indeed, and I am using git.  It is the fact that the surrounding test
suite is not submitted that means I need to work in a separate tree.  I
have since this incident looked back over the history and yours was the
only change that did not come through me and so the problem has been
restricted to that one change.

But to prevent it occuring again I have rejigged my tree so that I can
simply maintain a real git branch for just the checkpatch changes, in
parallel to the version with the tests.  This then allows me to merge
mainline and handle things correctly.

-apw
