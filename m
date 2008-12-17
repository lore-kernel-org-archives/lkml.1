Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751167AbYLQSr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbYLQSr3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYLQSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:47:18 -0500
Received: from kroah.org ([198.145.64.141]:47114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751099AbYLQSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:47:18 -0500
Date: Wed, 17 Dec 2008 10:24:44 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: driver probe error reporting
Message-ID: <20081217182444.GA26359@kroah.com>
References: <20081215231502.GC12431@fluff.org.uk> <20081217063655.GA12933@kroah.com> <200812171344.52872.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171344.52872.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 01:44:52PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 17 of December 2008, Greg KH wrote:
> > On Mon, Dec 15, 2008 at 11:15:02PM +0000, Ben Dooks wrote:
> > > This runs on from the discussion in [1] on how drivers (especially
> > > one using a variant of the device driver framework) report errors
> > > on probe. There are two main classes of errors, the type which happen
> > > at probe time (device not responding, not enough memory, etc) and
> > > errors that are due to configuration such as missing device configuration
> > > data.
> > > 
> > > It has been suggested that using dev_err() to report any configuration
> > > data error is a bloat of code as a properly debugged kernel should never
> > > find itself in this state.
> > > 
> > > Unfortunatley the only diagnostic dev_xxx() macro is dev_dbg() which is
> > > only available if the the driver code itself defines DEBUG. I would think
> > > it would be better to have a macro that can be turned on/off by a kernel
> > > configuration for when debugging which turns on the messages that are
> > > important to developers creating new machine/arch support but disabled
> > > for shipping kernels.
> > 
> > Not anymore, dev_dbg() can be dynamically switched on and off at runtime
> > in 2.6.28.
> 
> IMO, there's a problem with that, because it turns on _all_ of the debug info
> from the entire kernel, which is _never_ necessary.

No, it is turned on and off on a per-module basis, not for the whole
kernel (although that is possible if you so desire.)

So this should not be an issue.

thanks,

greg k-h
