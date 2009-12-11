Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZLKOpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZLKOpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbZLKOpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:45:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40522 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbZLKOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:45:14 -0500
Date: Fri, 11 Dec 2009 09:42:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Message-ID: <20091211144221.GA6663@tuxdriver.com>
References: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com> <20091211133603.46bec686@strolchi.home.s3e.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211133603.46bec686@strolchi.home.s3e.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 01:36:03PM +0100, Stefan Seyfried wrote:
> On Tue,  8 Dec 2009 15:21:33 +0100
> Stefan Seyfried <stefan.seyfried@googlemail.com> wrote:
> 
> > From: Stefan Seyfried <seife@sphairon.com>
> > 
> > The following two trivial patches add support for this device to
> > zd1211rw (ejecting the virtual USB drive) and ar9170usb (that drives
> > the WLAN chip inside).
> 
> Is anyhting wrong with those?
> Are those too trivial and "USB only" and thus better suited for direct
> submission to Greg?

Trivial or not, they are wireless LAN patches and they go here.

FWIW, you posted them in the middle of the maintainer's merge window
for 2.6.33.  So for now only fixes are being merged.  I wasn't sure
these qualified, although upon closer review they may.

It strikes me as strange that you are hitting two drivers to support
one device.  Are you saying that your ar9170usb has the goofy storage
device thing using the same USB IDs that the zd1211rw devices like that
used?  I suppose that makes some sense given the shared heritage...

We did just have a long (and possibly unresolved thread) about
this type of practice (i.e. eject in the driver) not too long ago.
But since zd1211rw is already doing this, maybe this patch is
acceptable...?

Anyway, I have your patch.  Please be patient.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
