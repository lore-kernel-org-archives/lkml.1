Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbYBGJ3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbYBGJ3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYBGJ3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:29:44 -0500
Received: from tim.rpsys.net ([194.106.48.114]:54693 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYBGJ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:29:42 -0500
Subject: Re: [PATH] misc,acpi,backlight: Compal Laptop Extras (2nd try)
From: Richard Purdie <rpurdie@rpsys.net>
To: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080205183820.65dcf111@debian>
References: <20080205183820.65dcf111@debian>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 09:29:23 +0000
Message-Id: <1202376563.9519.12.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 18:38 +0100, Cezary Jackiewicz wrote:
> From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> 
> This is driver for Compal Laptop: FL90/IFL90, based on MSI
> driver.
> 
> This driver exports a few files in /sys/devices/platform/compal-laptop/:
>  lcd_level - screen brightness: contains a single integer in the range 0..7 (rw)
>  wlan - wlan subsystem state: contains 0 or 1 (rw)
>  bluetooth - bluetooth subsystem state: contains 0 or 1 (rw)
>  raw - raw value taken from embedded controller register (ro)
> 
> In addition to these platform device attributes the driver registers itself
> in the Linux backlight control subsystem and is available to userspace under
> /sys/class/backlight/compal-laptop/.
> 
> Based on 2.6.24

If you use the backlight class do we really need to duplicate the
lcd_level file under sysfs too?

Richard

