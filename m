Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbXIZJGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbXIZJGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXIZJF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:05:57 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:37652 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbXIZJF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:05:56 -0400
Date: Wed, 26 Sep 2007 11:07:49 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Message-ID: <20070926090749.GI12137@enneenne.com>
References: <41784.213.84.50.107.1190624288.squirrel@webmail.enneenne.com> <20070924123408.596a3c69@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924123408.596a3c69@dhcp-255-175.norway.atmel.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [Linux-fbdev-devel] [RFC] driving a LCD panel via I2C
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:34:08PM +0200, Haavard Skinnemoen wrote:
> 
> I have a similar panel in the sense that it needs a bunch of SPI
> commands to get started. I implemented a LCD driver
> (drivers/video/backlight) for it so that it is automatically turned
> on/off at bootup/shutdown, and can be manually turned on/off
> through /sys/class/lcd/ltv350qv/power. AFAIK the driver is currently
> sitting in the backlight tree scheduled for inclusion in 2.6.24.

Mmm... it seems a good solution! :)

> Just implement it as a regular I2C chip driver which registers a device
> with the LCD framework when it is successfully probed.

Thanks for your suggestion.

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
