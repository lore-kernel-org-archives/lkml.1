Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZFXS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZFXS4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZFXS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:56:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52285 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZFXS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:56:07 -0400
Date: Wed, 24 Jun 2009 20:56:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu,
       ben-linux@fluff.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com
Subject: Re: [PATCH 00/07] pm: remove late/early platform driver pm
	callbacks V2
Message-ID: <20090624185602.GA7683@elf.ucw.cz>
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se> <200906242048.40956.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906242048.40956.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 20:48:39, Rafael J. Wysocki wrote:
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
> 
> Pavel, is your ACK for the entire series?

Well, I don't really understand stuff like dw_dmac.c, but it looks
basically okay to me. I guess ACK might be okay.

> >  arch/arm/plat-omap/debug-leds.c  |   11 +++++++----
> >  arch/arm/plat-omap/gpio.c        |   14 ++++++++++----
> >  drivers/base/platform.c          |   36 ------------------------------------
> >  drivers/dma/dw_dmac.c            |   15 ++++++++++-----
> >  drivers/dma/txx9dmac.c           |   15 ++++++++++-----
> >  drivers/i2c/busses/i2c-pxa.c     |   25 +++++++++++++++++--------
> >  drivers/i2c/busses/i2c-s3c2410.c |   25 ++++++++++++++++---------
> >  drivers/usb/musb/musb_core.c     |   18 ++++++++++++------
> >  include/linux/platform_device.h  |    2 --
> >  9 files changed, 82 insertions(+), 79 deletions(-)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
