Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXGHNqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXGHNqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXGHNqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:46:45 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:12977 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbXGHNqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:46:44 -0400
Date: Sun, 8 Jul 2007 09:39:10 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Adrian Bunk <bunk@stusta.de>, r.marek@assembler.cz,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [2.6 patch] make coretemp_device_remove() static
Message-ID: <20070708133910.GB3591@jupiter.solarsys.private>
References: <20070705232306.GY3492@stusta.de> <20070707212228.1e776ff8@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707212228.1e776ff8@hyperion.delvare>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean, Adrian:

* Jean Delvare <khali@linux-fr.org> [2007-07-07 21:22:28 +0200]:
> Hi Adrian,
> 
> On Fri, 6 Jul 2007 01:23:06 +0200, Adrian Bunk wrote:
> > coretemp_device_remove() can become static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> Obviously correct.
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> > ---
> > --- linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c.old	2007-07-04 20:46:05.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/drivers/hwmon/coretemp.c	2007-07-04 20:46:20.000000000 +0200
> > @@ -318,7 +318,7 @@
> >  }
> >  
> >  #ifdef CONFIG_HOTPLUG_CPU
> > -void coretemp_device_remove(unsigned int cpu)
> > +static void coretemp_device_remove(unsigned int cpu)
> >  {
> >  	struct pdev_entry *p, *n;
> >  	mutex_lock(&pdev_list_mutex);

Applied to my testing tree; thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

