Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZCAUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZCAUNr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 15:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZCAUNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 15:13:39 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:49056 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZCAUNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 15:13:38 -0500
Message-ID: <49AAEC6D.9000200@krogh.cc>
Date: Sun, 01 Mar 2009 21:13:33 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>	 <49A6F39F.9040801@krogh.cc>	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>	 <49A6FEE2.90700@krogh.cc>	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>	 <49A70B24.6090706@krogh.cc>	 <1235685269.6811.11.camel@localhost.localdomain>	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc> <1235766936.7402.5.camel@localhost.localdomain>
In-Reply-To: <1235766936.7402.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
>> Working (clocksource=tsc) 2.6.26.8
>> jk@quad03:~$ ntpdc -c kerninfo
>> pll offset:           0.003208 s
>> pll frequency:        -25.070 ppm
> [snip]
>> Non-working (clocksource=tsc) 2.6.29-rc6
>> jk@quad12:~$ ntpdc -c kerninfo
>> pll offset:           0 s
>> pll frequency:        -34.754 ppm
> 
> 
> Ok, so it seems ntp hasn't really had a chance to settle down, its only
> made a 10ppm adjustment so far. NTPd will stop corrections at ~
> +/-500ppm, so you're not at that bound yet, where things would be really
> broken.

But I should settle within a "reasonable" period of time? (not hours?).

> If the affected kernel isn't resetting in the logs anymore, I'd be
> interested in what the new ppm value is.

I keeps resetting after 7 hours ..   Is there more information I can 
provide?

Jesper

-- 
Jesper
