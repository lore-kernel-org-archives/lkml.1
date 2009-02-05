Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbZBESQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbZBESQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760824AbZBESPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:15:43 -0500
Received: from kroah.org ([198.145.64.141]:55755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755627AbZBESPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:15:41 -0500
Date: Thu, 5 Feb 2009 10:08:56 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tom.leiming@gmail.com, kay.sievers@vrfy.org, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v3)
Message-ID: <20090205180856.GA20805@kroah.com>
References: <1233319715-4877-1-git-send-email-tom.leiming@gmail.com> <20090130065224.47729f41@infradead.org> <20090204230851.GF18484@kroah.com> <20090204170858.2d07b546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204170858.2d07b546@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 05:08:58PM -0800, Arjan van de Ven wrote:
> On Wed, 4 Feb 2009 15:08:51 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Jan 30, 2009 at 06:52:24AM -0800, Arjan van de Ven wrote:
> > > On Fri, 30 Jan 2009 20:48:35 +0800
> > > tom.leiming@gmail.com wrote:
> > > 
> > > > From: Ming Lei <tom.leiming@gmail.com>
> > > > 
> > > > This patch adds a function : driver_wait_probe_done,
> > > > which waits on condition of probing done to replace
> > > > polling for driver_probe_done in fs initialization.
> > > > 
> > > > There is no better way to avoid polling for
> > > > driver_probe_done _and_ existence of the root device,
> > > > so we does not replace the driver_probe_done with
> > > > driver_wait_probe_done in such special case.
> > > > 
> > > > Removing polling in fs initialization may lead to
> > > > a faster boot.
> > > > 
> > > > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > > 
> > > ok this one will work fine ;)
> > > 
> > > Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
> > > 
> > > thanks for fixing this up 
> > > (it will clash with the patch that moves this to one place, but the
> > > same cleanup can be done there)
> > 
> > What patch is that?  Should i be taking this?  Or are they in some
> > other tree?
> 
> it's the suspend-resume regression fixes that either you already have
> or that raphael sent to you

Hm, ok, I don't see any left in my tree, or queue, so perhaps someone
might want to resend them to me?

thanks,

greg k-h
