Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888Ab0AaJwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0AaJwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 04:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993Ab0AaJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 04:52:36 -0500
Received: from bamako.nerim.net ([62.4.17.28]:62245 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab0AaJwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 04:52:35 -0500
Date: Sun, 31 Jan 2010 10:52:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: Re: i2c_powermac: Kernel access of bad area
Message-ID: <20100131105231.23d70990@hyperion.delvare>
In-Reply-To: <alpine.DEB.2.01.1001302156380.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de>
	<1262079255.2173.216.camel@pasglop>
	<20100106173745.57207520@hyperion.delvare>
	<alpine.DEB.2.01.1001061913310.3483@bogon.housecafe.de>
	<20100107171738.2c83b13e@hyperion.delvare>
	<20100129091857.3b7228db@hyperion.delvare>
	<alpine.DEB.2.01.1001292202150.3483@bogon.housecafe.de>
	<alpine.DEB.2.01.1001302156380.3483@bogon.housecafe.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 22:05:26 -0800 (PST), Christian Kujau wrote:
> OK, I've now applied both the drivers/hwmon/ams/ patches and your earlier 
> one for drivers/macintosh/therm_adt746x.c [0] to a current -git checkout 
> and now I can unload i2c_powermac, list and read the remaining files in
> /sys/devices/temperatures, load i2c_powermac again, and unload, and
> load, and ... - it's wonderful! :-) No oopses so far.
> 
> Feel free to add a Tested-by: Christian Kujau <lists@nerdbynature.de>
> so that the patches can be pushed into mainline.

Thanks, I'll resend both patches with proper comments and headers now.

> Thanks for the fixes, Jean!

You're welcome.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
