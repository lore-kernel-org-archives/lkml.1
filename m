Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZGDXot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZGDXot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 19:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGDXoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 19:44:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbZGDXof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 19:44:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 00/07] pm: remove late/early platform driver pm callbacks V2
Date: Sun, 5 Jul 2009 01:45:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, pavel@ucw.cz,
       hskinnemoen@atmel.com, anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu,
       ben-linux@fluff.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090624092306.14276.127.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907050145.15122.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Magnus Damm wrote:
> pm: remove late/early platform driver pm callbacks V2
> 
> [PATCH 01/07] arm: rework omap suspend_late()/resume_early()
> [PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
> [PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
> [PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
> [PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
> [PATCH 06/07] usb: rework musb suspend()/resume_early()
> [PATCH 07/07] pm: remove platform device suspend_late()/resume_early() V2
> 
> These patches simply remove ->suspend_late() and ->resume_early()
> from struct platform_driver. Drivers are converted to dev_pm_ops
> with CONFIG_SUSPEND in mind. Untested.
> 
> All patches except [02/07] are known to compile.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Changes since V1:
>  - resolved conflicts in [05/07], rediffed [07/07]
>  - include lkml, linux-usb and akpm
> 
>  arch/arm/plat-omap/debug-leds.c  |   11 +++++++----
>  arch/arm/plat-omap/gpio.c        |   14 ++++++++++----
>  drivers/base/platform.c          |   36 ------------------------------------
>  drivers/dma/dw_dmac.c            |   15 ++++++++++-----
>  drivers/dma/txx9dmac.c           |   15 ++++++++++-----
>  drivers/i2c/busses/i2c-pxa.c     |   25 +++++++++++++++++--------
>  drivers/i2c/busses/i2c-s3c2410.c |   25 ++++++++++++++++---------
>  drivers/usb/musb/musb_core.c     |   18 ++++++++++++------
>  include/linux/platform_device.h  |    2 --
>  9 files changed, 82 insertions(+), 79 deletions(-)

The series is now in the linux-next branch of the suspend-2.6 tree.  I'll move
it into the for-linus branch, which is not rebased, if the patches are not
reported to cause any problems in the next few days.

Best,
Rafael
