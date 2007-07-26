Return-Path: <linux-kernel-owner+w=401wt.eu-S936559AbXGZU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936559AbXGZU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765395AbXGZU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:58:15 -0400
Received: from tartu.cyber.ee ([193.40.6.68]:2948 "EHLO tartu.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764494AbXGZU6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:58:14 -0400
From: Meelis Roos <mroos@linux.ee>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl (Rafael J. Wysocki)
Subject: Re: [2.6.23-rc1 REGRESSION] ThinkPad T42 poweroff failure by
"PM: Introduce pm_power_off_prepare"
In-Reply-To: <200707261629.55741.rjw@sisk.pl>
User-Agent: tin/1.9.2-20070201 ("Dalaruan") (UNIX) (Linux/2.6.23-rc1-ge4903fb5 (i686))
Message-Id: <20070726205753.9351313FEB@rhn.tartu-labor>
Date: Thu, 26 Jul 2007 23:57:53 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, so here it goes again with a changelog:
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Generally, sysdev_shutdown() should be called after the ACPI preparation for
> powering the system off.  To make it happen, we can separate sysdev_shutdown()
> from device_shutdown() and call it directly wherever necessary.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

It also fixes the same problem on Thinkpad X20 - thanks!

--
Meelis Roos <mroos@linux.ee>
