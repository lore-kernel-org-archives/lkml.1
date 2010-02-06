Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab0BFSBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 13:01:23 -0500
Received: from poutre.nerim.net ([62.4.16.124]:58039 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0BFSBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 13:01:21 -0500
Date: Sat, 6 Feb 2010 19:01:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Rob Owings <rowings@thermistor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, lm-sensors@lm-sensors.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] linux-2.6.32-directemp
Message-ID: <20100206190117.6fc3be63@hyperion.delvare>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C2445C2@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
	<20100206104251.1be31941@neptune.home>
	<68FBE0F3CE97264395875AC1C468F22C2445C2@mail03.cyberswitching.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010 08:58:14 -0800, Chris Verges wrote:
> > Wouldn't it make sense to make use of hardware monitoring interfaces so
> > lm_sensors could handle the sensor information? (added to CC)
> >
> > This would also be a good reason to have the driver on kernel side
> > rather than somewhere in userspace.
> 
> Hi Bruno,
> 
> I agree.  However, I've had other drivers in the past been pooh-pooh'd by the lm-sensors maintainers because they don't seem to fit exactly what the lm-sensors folks want in a driver.  Unfortunately, I  seem to be bad at understanding the purpose of lm-sensors.  :-)  I'd like to get their approval before any work is done to migrate over to lm-sensors.

I can see that you tried to submit a driver for an accelerometer chip.
This indeed did not quite fit in the hwmon subsystem (although for
historical and unfortunate reasons we have a couple of them sitting
there at the moment... they should really go away!)

Temperature sensors definitely fit in the hwmon subsystem.

Humidity sensors... why not, we have already one.

-- 
Jean Delvare
