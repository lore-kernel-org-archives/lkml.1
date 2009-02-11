Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZBKXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZBKXgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZBKXgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:36:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:48987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbZBKXgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:36:06 -0500
Date: Wed, 11 Feb 2009 15:34:11 -0800
From: Greg KH <gregkh@suse.de>
To: Shawn Bohrer <shawn.bohrer@ni.com>
Cc: fmhess@users.sourceforge.net, linux-kernel@vger.kernel.org,
       abbotti@mev.co.uk, ds@schleef.org
Subject: Re: [staging] High level Comedi feedback
Message-ID: <20090211233411.GA21860@suse.de>
References: <20090209180144.GD18058@bohrers.amer.corp.natinst.com> <200902092238.49109.fmhess@speakeasy.net> <20090211231728.GC23561@bohrers.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211231728.GC23561@bohrers.amer.corp.natinst.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 05:17:28PM -0600, Shawn Bohrer wrote:
> Hey Frank,
> 
> On Mon, Feb 09, 2009 at 10:38:44PM -0500, Frank Mori Hess wrote:
> > On Monday 09 February 2009 13:01, Shawn Bohrer wrote:
> > > 6. COMEDI doesn't yet support configuring hardware buffer sizes for deep
> > > on-board FIFOs.
> >
> > There is INSN_CONFIG_BLOCK_SIZE, which a couple drivers use to configure
> > their hardware fifo size.
> 
> Thanks I'll take a close look at this.
> 
> > By the way, I'm not subscribed to linux-kernel.  Comedi does have its own
> > mailing list, maybe this kind of discussion would be easier on a more
> > specific, lower traffic list?
> 
> Since Comedi is working its way into the kernel I'd like to get a
> little broader exposure on some of the things that we'd like to see
> improved before any interfaces get set in stone.  I think it could be
> beneficial to cc the Comedi list, but it looks like that list only
> accepts emails from subscribers.

The Comedi interface is not set in stone at all yet.  I've just
integrated the core, and am still adding the remaining drivers
(hopefully get to the rest of them tomorrow).  Then we can start
cleaning up the interfaces between the core and drivers, and review the
external interface as well, to see if it is lacking in any way, or not
working properly for any specific users (like yourself.)

Sound good?

thanks,

greg k-h
