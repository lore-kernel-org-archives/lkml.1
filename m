Return-Path: <linux-kernel-owner+w=401wt.eu-S1423054AbXEDUhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423054AbXEDUhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423055AbXEDUhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:37:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54884 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423054AbXEDUhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:37:36 -0400
Subject: Re: cpufreq longhaul locks up
From: john stultz <johnstul@us.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: davej@codemonkey.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@lists.linux.org.uk
In-Reply-To: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Fri, 04 May 2007 13:37:32 -0700
Message-Id: <1178311052.6094.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 12:16 +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> I found that setting the cpufreq governor to ondemand making the box 
> lock up solid in 2.6.20.2 and 2.6.21 after a few seconds. Sysrq 
> does not work anymore, and the last messages are:
> 
> May  3 19:16:58 cn kernel: longhaul: VIA C3 'Nehemiah C' [C5P] CPU 
> detected.  Powersaver supported.
> May  3 19:16:58 cn kernel: longhaul: Using northbridge support.
> May  3 19:17:22 cn kernel: Time: acpi_pm clocksource has been installed.
> May  3 19:17:22 cn kernel: Clocksource tsc unstable (delta = -136422685 
> ns)

What happens if you boot wihtout the ondemand governor but w/ clocksource=acpi_pm ? 


thanks
-john


