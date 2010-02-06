Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab0BFJuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:50:35 -0500
Received: from ppp-156-202.adsl.restena.lu ([158.64.156.202]:52053 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0BFJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:50:34 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2010 04:50:34 EST
Date: Sat, 6 Feb 2010 10:42:51 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Rob Owings" <rowings@thermistor.com>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-ID: <20100206104251.1be31941@neptune.home>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 February 2010 "Chris Verges" wrote:
> Attached is a patch for the QTI DirecTEMP USB thermometer &
> thermometer/hygrometer sensors.  This patch is based on linux-2.6.32.
> Functionality has been verified against both hardware variants listed
> in the driver (0x0002 and 0x0006), as both monolithic and modular.
> 
> When the QTI DirecTEMP sensor is connected to a system, the directemp
> driver adds appropriate sysfs entries for the sensor type(s)
> supported. Examples:
> 
>    # PID 0x0002 (temp only)
>    /sys/bus/usb/devices/.../temp
> 
>    # PID 0x0006 (temp + relative humidity)
>    /sys/bus/usb/devices/.../temp
>    /sys/bus/usb/devices/.../rh
> 
> Using a standard "cat" will display the value.

Wouldn't it make sense to make use of hardware monitoring interfaces so
lm_sensors could handle the sensor information? (added to CC)

This would also be a good reason to have the driver on kernel side
rather than somewhere in userspace.

Bruno
