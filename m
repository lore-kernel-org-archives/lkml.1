Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZFWPl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZFWPl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760740AbZFWPlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:41:14 -0400
Received: from kroah.org ([198.145.64.141]:42553 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760837AbZFWPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:41:13 -0400
Date: Tue, 23 Jun 2009 08:29:16 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: driver-core tree build failure
Message-ID: <20090623152916.GA27467@kroah.com>
References: <20090623160100.ab086e63.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623160100.ab086e63.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:01:00PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next build (arm omap_osk_5912_defconfig) failed like this:
> 
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_caps_num':
> drivers/video/omap/omapfb_main.c:1253: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_caps_text':
> drivers/video/omap/omapfb_main.c:1273: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_panel_name':
> drivers/video/omap/omapfb_main.c:1320: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_bklight_level':
> drivers/video/omap/omapfb_main.c:1329: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_store_bklight_level':
> drivers/video/omap/omapfb_main.c:1344: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_bklight_max':
> drivers/video/omap/omapfb_main.c:1363: error: 'struct device' has no member named 'driver_data'
> drivers/video/omap/omapfb_main.c: In function 'omapfb_show_ctrl_name':
> drivers/video/omap/omapfb_main.c:1396: error: 'struct device' has no member named 'driver_data'
> 
> Caused by commit 53d8ba57f16029a47ed5df9840ab6c3f9abd3727 ("Driver core:
> move dev_get/set_drvdata to drivers/base/dd.c") from the driver-core tree.
> 
> I see more grepping in your future :-)

Heh, thanks, I got i386, x86-64, and ppc64 working properly this time
around, but new things keep slipping in :)

I'll go resolve these as well.

thanks,

greg k-h
