Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXHEPWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXHEPWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXHEPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:21:58 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:25676 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXHEPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:21:57 -0400
Date: Sun, 5 Aug 2007 11:17:37 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070805151737.GH6221@jupiter.solarsys.private>
References: <46B5B290.4040907@s5r6.in-berlin.de> <20070805135500.GF6221@jupiter.solarsys.private> <46B5E3DB.1060205@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5E3DB.1060205@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan:

* Stefan Richter <stefanr@s5r6.in-berlin.de> [2007-08-05 16:51:07 +0200]:
> Mark M. Hoffman wrote:
> > It's more likely the patch before that:
> > 
> > 	hwmon/w83627ehf: Preserve speed reading when changing fan min
> 
> I reverted this patch alone and rebooted, still the same problem.
> After reboot:
>    0 RPM for case fan,
>    correct CPU fan speed, drops to 1/16 after kmsensors' first refresh
> After unloading and reloading the driver:
>    correct speed of case fan,
>    correct CPU fan speed, drops to 1/16 after kmsensors' first refresh

OK, thanks for trying that.  I'll keep looking here.

> > I'll reexamine the patch series here.  If you have time, it would help if you
> > could do a git bisect.  Use this command:
> > 
> > $ git bisect start v2.6.23-rc2 v2.6.22-rc5 drivers/hwmon/w83627ehf.c
> > 
> > Doing it this way will force you to reboot between tests; I think we would
> > need that anyway.
> 
> I'll try to reserve the time for that on some evening next week.
> Thanks,

There are a total of 9 patches between v2.6.22-rc5 and v2.6.23-rc2, so the
bisection shouldn't take long.  Also, please enable HWMON_DEBUG when you do
this, and send the resulting syslog messages.  Thanks.

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

