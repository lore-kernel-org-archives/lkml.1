Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbXDAG2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbXDAG2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932785AbXDAG2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:28:48 -0400
Received: from gw.goop.org ([64.81.55.164]:49617 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbXDAG2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:28:47 -0400
Message-ID: <460F511E.2090102@goop.org>
Date: Sat, 31 Mar 2007 23:28:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com>
In-Reply-To: <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Could you try to unload or disable hardware sensors and check if it
> helps?
> CONFIG_I2C=m
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCA=m
> CONFIG_I2C_I810=m
> CONFIG_I2C_PIIX4=m
> CONFIG_SENSORS_DS1337=m
> CONFIG_SENSORS_DS1374=m
> CONFIG_SENSORS_EEPROM=m
> CONFIG_SENSORS_PCF8574=m
> CONFIG_SENSORS_PCA9539=m
> CONFIG_SENSORS_PCF8591=m
> CONFIG_SENSORS_MAX6875=m

That seems to have helped.  If I watch
/proc/acpi/thermal_zone/THM?/temperature, it seems stable even under
load.   I didn't try watching the thermal_zones when these options were
enabled, but I presume the temperature was not controlled for it to hit
128 degC.

What's going on here?  Does reading an i2c sensor from the kernel
prevent something else from doing it?

    J
