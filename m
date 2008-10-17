Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYJQQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYJQQ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJQQ2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:28:08 -0400
Received: from mlbe2k1.cs.myharris.net ([137.237.90.88]:54055 "EHLO
	mlbe2k1.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJQQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:28:06 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 12:28:06 EDT
Message-ID: <48F8B833.7080807@harris.com>
Date: Fri, 17 Oct 2008 12:07:15 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7 RFC] Handle I2C GPIO controllers with the OF (was:
 pca9539 I2C gpio expander)
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2008 16:07:16.0775 (UTC) FILETIME=[6CDF5370:01C93072]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> Hi all,
> 
> Recently there was a question about I2C GPIO controllers and how should
> we handle them with the OpenFirmware and such.
> 
> Here is the attempt to "connect" I2C GPIO controllers to the
> "OpenFirmware" device tree, without writing an OF-specific bindings
> for each driver.
> 
> The salt is in these two patches:
> 
> [PATCH 3/7] of: fill the archdata for I2C devices
> ^ Here we're storing the device tree node into the I2C device.
> 
> [PATCH 5/7] of/gpio: implement of_dev_gpiochip_{add,remove} calls
> ^ And here we extracting the the stored node to put the registered
>   of_gpio_chip into that node.
> 
> 
> How does it look?

I've just tested this with a pca9539 chip attached to my Sequoia board,
and it works perfectly for me.  I don't have the mcu_mpc8349emitx.c file
in my tree, so I was not able to apply part 7 of 7, but the rest looks
fine.  Thanks for doing this.

Acked by: Steve Falco <sfalco@harris.com>
