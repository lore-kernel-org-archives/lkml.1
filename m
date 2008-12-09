Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYLICOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYLICOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 21:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLICOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 21:14:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43510 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYLICOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 21:14:07 -0500
Subject: Re: 2.6.27.7 built for Geode: Clock drift
From: john stultz <johnstul@us.ibm.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <493A170C.90509@t-online.de>
References: <49358017.7080009@t-online.de>
	 <1f1b08da0812051340t1967e753h354346d13ccb34d3@mail.gmail.com>
	 <493A170C.90509@t-online.de>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 18:14:00 -0800
Message-Id: <1228788840.6918.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-06 at 07:09 +0100, Harald Dunkel wrote:
> john stultz wrote:
> > 
> > For both configs, can you run:
> >    cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > and:
> >    cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > 
> > Then send back the output?
> > 
> 
> Sure. For 486:
> 
> % cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> pit jiffies
> % cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> pit
> 
> 
> For Geode (clock is running too fast):
> % cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> jiffies
> % cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> jiffies
> 
> 
> dmesg says for Geode:
> 
> :
> TSC: Unable to calibrate against PIT
> TSC: No reference (HPET/PMTIMER) available
> Marking TSC unstable due to could not calculate TSC khz

Could you send your .config?

It seems the PIT (which is used in 486 build) is being disabled in the
Geode config. However, I thought the Geode's had their own clocksources,
either the SCx200 or the GEODE_MFGPT_TIMER. Maybe one of those needs to
be enabled?

thanks
-john


