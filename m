Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXHEOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXHEOve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXHEOvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 10:51:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57065 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXHEOvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 10:51:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B5E3DB.1060205@s5r6.in-berlin.de>
Date: Sun, 05 Aug 2007 16:51:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
References: <46B5B290.4040907@s5r6.in-berlin.de> <20070805135500.GF6221@jupiter.solarsys.private>
In-Reply-To: <20070805135500.GF6221@jupiter.solarsys.private>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark M. Hoffman wrote:
> It's more likely the patch before that:
> 
> 	hwmon/w83627ehf: Preserve speed reading when changing fan min

I reverted this patch alone and rebooted, still the same problem.
After reboot:
   0 RPM for case fan,
   correct CPU fan speed, drops to 1/16 after kmsensors' first refresh
After unloading and reloading the driver:
   correct speed of case fan,
   correct CPU fan speed, drops to 1/16 after kmsensors' first refresh

> I'll reexamine the patch series here.  If you have time, it would help if you
> could do a git bisect.  Use this command:
> 
> $ git bisect start v2.6.23-rc2 v2.6.22-rc5 drivers/hwmon/w83627ehf.c
> 
> Doing it this way will force you to reboot between tests; I think we would
> need that anyway.

I'll try to reserve the time for that on some evening next week.
Thanks,
-- 
Stefan Richter
-=====-=-=== =--- --=-=
http://arcgraph.de/sr/
