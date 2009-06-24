Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZFXU47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZFXU47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZFXU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:56:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZFXU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:56:44 -0400
Date: Wed, 24 Jun 2009 13:33:52 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp,
       linux-usb@vger.kernel.org, akpm@linux-foundation.org,
       stern@rowland.harvard.edu, ben-linux@fluff.org,
       linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       felipe.balbi@nokia.com
Subject: Re: [PATCH 00/07] pm: remove late/early platform driver pm
	callbacks V2
Message-ID: <20090624203352.GA28516@suse.de>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se> <200906242048.40956.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906242048.40956.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 08:48:39PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 24 June 2009, Magnus Damm wrote:
> > pm: remove late/early platform driver pm callbacks V2
> > 
> > [PATCH 01/07] arm: rework omap suspend_late()/resume_early()
> > [PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
> > [PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
> > [PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
> > [PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
> > [PATCH 06/07] usb: rework musb suspend()/resume_early()
> > [PATCH 07/07] pm: remove platform device suspend_late()/resume_early() V2
> > 
> > These patches simply remove ->suspend_late() and ->resume_early()
> > from struct platform_driver. Drivers are converted to dev_pm_ops
> > with CONFIG_SUSPEND in mind. Untested.
> > 
> > All patches except [02/07] are known to compile.
> > 
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> 
> If no one objects, I'd like to take this series into the suspend-2.6 tree as
> 2.6.32 material.  Greg?

Looks good to me, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the whole series.

thanks,

greg k-h
