Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbZE1AAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbZE1AAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758782AbZE1AAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:00:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42591
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755965AbZE1AAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:00:23 -0400
Date: Wed, 27 May 2009 17:00:23 -0700 (PDT)
Message-Id: <20090527.170023.245980842.davem@davemloft.net>
To: r.schwebel@pengutronix.de
Cc: grant.likely@secretlab.ca, plagnioj@jcrosoft.com,
       devicetree-discuss@ozlabs.org, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       jonsmirl@gmail.com, scottwood@freescale.com, yuan-bo.ye@motorola.com,
       timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090527235704.GQ6805@pengutronix.de>
References: <20090527193927.GD30039@game.jcrosoft.org>
	<fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com>
	<20090527235704.GQ6805@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Schwebel <r.schwebel@pengutronix.de>
Date: Thu, 28 May 2009 01:57:05 +0200

> On Wed, May 27, 2009 at 02:22:50PM -0600, Grant Likely wrote:
>> 2) Driver binding mechanism:  device tree nodes usually have a
>> "compatible" property which is a list of strings. The first string
>> describes exactly what the device is (ie. "atmel,24c08") and an
>> optional list of other devices which it is register interface
>> backwards compatible with.
> 
> This is a good example. The "exact" description above doesn't say
> anything about some of the details the driver needs to know. Here is the
> at24 driver:
> 
> http://lxr.linux.no/linux+v2.6.29/include/linux/i2c/at24.h#L18
> 
> Where do we get the page size & flags from?

You can use device node properties.

Every device node has mode than just a "name" and "compatible"
property.  You can add arbitrary properties, which are simply name -->
value pairs.  The type of the value is opaque, it can be any arbitrary
binary data, a string, a 32-bit integer, a MAC address, etc.
