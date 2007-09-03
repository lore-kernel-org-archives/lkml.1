Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXICKIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXICKIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXICKIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:08:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48780 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbXICKIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:08:36 -0400
Date: Mon, 3 Sep 2007 03:58:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070903035854.GD3655@ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <20070829080827.GD6832@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070829080827.GD6832@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-08-29 13:38:27, Gautham R Shenoy wrote:
> Hi Pavel,
> On Mon, Aug 27, 2007 at 12:43:50PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > x60, i386 architecture).
> > 
> 
> That's strange. 
> 
> I've been running cpu offline/online tests with kern bench, 
> cpufreq-ondemand and a few rt-tasks running in the background
> and it has worked for me. 
> Something like 100 iterations without a problem. But these were on
> machines with 4-8 cpus.  So may be this could be something specific to
> the dual cpu machine.

Seems like it is specific to nohz/highrestimers. 

> Can you post the .config? I'll try to recreate it?

Will send privately.

> > Plus I guess it would be nice to add CPU HOTPLUG into MAINTAINERS
> > file:
> > 
> 
> There is a list of maintainers in the Documentation/cpu-hotplug.txt, 
> which includes maintainers for different platforms as well.
> 
> It's a good idea to add that info to the MAINTAINERS file as well.

Yes, please.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
