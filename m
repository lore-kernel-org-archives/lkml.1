Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbXH2IJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbXH2IJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXH2IIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:08:49 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXH2IIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:08:47 -0400
Date: Wed, 29 Aug 2007 13:38:27 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070829080827.GD6832@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070827104350.GA2073@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827104350.GA2073@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,
On Mon, Aug 27, 2007 at 12:43:50PM +0200, Pavel Machek wrote:
> Hi!
> 
> Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> x60, i386 architecture).
> 

That's strange. 

I've been running cpu offline/online tests with kern bench, 
cpufreq-ondemand and a few rt-tasks running in the background
and it has worked for me. 
Something like 100 iterations without a problem. But these were on
machines with 4-8 cpus.  So may be this could be something specific to
the dual cpu machine.

Can you post the .config? I'll try to recreate it?

It's really strange since you mention that it tooks was  
an echo 1/0 into the sysfs file to break it. 

> Plus I guess it would be nice to add CPU HOTPLUG into MAINTAINERS
> file:
> 

There is a list of maintainers in the Documentation/cpu-hotplug.txt, 
which includes maintainers for different platforms as well.

It's a good idea to add that info to the MAINTAINERS file as well.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
