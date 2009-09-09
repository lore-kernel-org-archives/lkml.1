Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZIIWIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZIIWIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZIIWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:08:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZIIWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:08:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/07] pm: remove late/early platform driver pm callbacks V2
Date: Thu, 10 Sep 2009 00:09:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, pavel@ucw.cz, hskinnemoen@atmel.com,
       anemo@mba.ocn.ne.jp, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu,
       ben-linux@fluff.org, linux-omap@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, felipe.balbi@nokia.com,
       nicolas.ferre@atmel.com, linux-next@vger.kernel.org
References: <20090624092306.14276.127.sendpatchset@rx1.opensource.se> <200907050145.15122.rjw@sisk.pl> <e9c3a7c20909081825i1578a522w5d7f4e5d678b5d74@mail.gmail.com>
In-Reply-To: <e9c3a7c20909081825i1578a522w5d7f4e5d678b5d74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100009.48504.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Dan Williams wrote:
> 2009/7/4 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday 24 June 2009, Magnus Damm wrote:
> >> pm: remove late/early platform driver pm callbacks V2
> >>
> >> [PATCH 01/07] arm: rework omap suspend_late()/resume_early()
> >> [PATCH 02/07] dma: rework dw_dmac suspend_late()/resume_early()
> >> [PATCH 03/07] dma: rework txx9dmac suspend_late()/resume_early()
> >> [PATCH 04/07] i2c: rework i2c-pxa suspend_late()/resume_early()
> >> [PATCH 05/07] i2c: rework i2c-s3c2410 suspend_late()/resume() V2
> >> [PATCH 06/07] usb: rework musb suspend()/resume_early()
> >> [PATCH 07/07] pm: remove platform device suspend_late()/resume_early() V2
> >>
> >> These patches simply remove ->suspend_late() and ->resume_early()
> >> from struct platform_driver. Drivers are converted to dev_pm_ops
> >> with CONFIG_SUSPEND in mind. Untested.
> >>
> >> All patches except [02/07] are known to compile.
> >>
> >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> [..]
> >
> > The series is now in the linux-next branch of the suspend-2.6 tree.  I'll move
> > it into the for-linus branch, which is not rebased, if the patches are not
> > reported to cause any problems in the next few days.
> >
> 
> Hi,
> 
> My linux-next test builds for drivers/dma/ caught a missed conversion
> of the at_hdmac driver.  Please check the attached fix (compile tested
> only) and include it in this series.

Applied to suspend-2.6/linux-next, thanks.

Best,
Rafael
