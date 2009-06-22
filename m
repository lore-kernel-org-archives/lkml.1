Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZFVU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZFVU4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZFVU4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:56:42 -0400
Received: from kroah.org ([198.145.64.141]:49839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZFVU4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:56:42 -0400
Date: Mon, 22 Jun 2009 13:51:50 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
Message-ID: <20090622205150.GA10360@kroah.com>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com> <20090614230044.GA21624@pengutronix.de> <20090622151515.GA16627@pengutronix.de> <20090622171948.GA15145@kroah.com> <1245693964.32124.52.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245693964.32124.52.camel@desktop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:06:04AM -0700, Daniel Walker wrote:
> On Mon, 2009-06-22 at 10:19 -0700, Greg KH wrote:
> > On Mon, Jun 22, 2009 at 05:15:15PM +0200, Uwe Kleine-König wrote:
> > > Hi Greg,
> > > 
> > > On Mon, Jun 15, 2009 at 01:00:44AM +0200, Uwe Kleine-König wrote:
> > > > On Sun, Jun 14, 2009 at 04:28:02AM -0700, Greg KH wrote:
> > > > > On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> > > > > > I know that at least COMEDI and RT2870 are broken with -rt,
> > > > > 
> > > > > I didn't know this, has anyone sent me a bug report?  What in -rt causes
> > > > > these drivers to break?
> > > > > 
> > > > > > but Thomas requested disabling all of staging.  He's the maintainer.
> > > > > 
> > > > > This seems like a patch to ensure that the staging drivers never get a
> > > > > chance to be fixed for any potential -rt issues.  How about just sending
> > > > > me bug reports instead?
> > > > I cannot reproduce the failure I saw for RT2870 at the moment.
> > > OK, hit again:
> > > 
> > > 17:02:43 E: ERROR: "there_is_no_init_MUTEX_LOCKED_for_RT_semaphores" [drivers/staging/rt2870/rt2870sta.ko] undefined!
> > 
> > What needs to be done in the rt2870 driver to resolve this issue?
> 
> The semaphore needs to be converted to a completion. Or the code needs
> to be re-worked so it can use a mutex.

Patches gladly accepted :)

thanks,

greg k-h
