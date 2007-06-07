Return-Path: <linux-kernel-owner+w=401wt.eu-S966508AbXFGX3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966508AbXFGX3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764995AbXFGX2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:28:51 -0400
Received: from tim.rpsys.net ([194.106.48.114]:59257 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764733AbXFGX2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:28:48 -0400
Subject: Re: [PATCH 2/2] LEDS: generic driver
From: Richard Purdie <rpurdie@rpsys.net>
To: Robin Farine <robin.farine@terminus.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706061902.06738.robin.farine@terminus.org>
References: <ab8cd0edce36b4ea93429c7ab695f5a967b11365.1181149111.git.robin.farine@terminus.org>
	 <200706061902.06738.robin.farine@terminus.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 00:27:52 +0100
Message-Id: <1181258872.30600.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 19:02 +0200, Robin Farine wrote: 
> From: Robin Farine <robin.farine@terminus.org>
> 
> This generic LED driver implements the platform independent part of a
> LED driver letting platform specific code focus on the hardware
> details. The driver binds to platform devices named "Generic-LED"
> which provide the platform specific data and code needed to act on an
> LED.
> 
> This is useful for platforms with exotic ways of controlling LEDs
> which preclude the use of a common LED driver such as GPIO based
> drivers.
> 
> Signed-off-by: Robin Farine <robin.farine@terminus.org>

I'm not sure about this to be honest. I can see a case for perhaps
having a couple of standard suspend/resume functions for platform device
based LED drivers as those functions are often identical. I'm not sure
whether there is going to be much need for more than that.

Having looked through a few of the LED drivers, even the suspend/resume
functions are often different...

>From a style point of view, why not s/pdev_to_led/platform_get_drvdata/?

What are your thoughts on multiple LEDs on a single device?

Given the LED class is going to get a conversion to struct device soon,
I'd prefer to put this on hold until after I've made that conversion at
which point I'll reconsider this.

Regards,

Richard


