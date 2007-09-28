Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbXI1PCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbXI1PCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXI1PCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:02:36 -0400
Received: from www.osadl.org ([213.239.205.134]:35474 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752495AbXI1PCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:02:36 -0400
Subject: Re: [PATCH] disable non-boot CPUs before poweroff
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Lord <lkml@rtr.ca>, Len Brown <lenb@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, simon.derr@bull.net
In-Reply-To: <200709281705.18304.rjw@sisk.pl>
References: <46FC20B7.4000606@rtr.ca> <46FD05B8.2040302@rtr.ca>
	 <46FD0724.5060009@rtr.ca>  <200709281705.18304.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 17:02:30 +0200
Message-Id: <1190991750.18681.39.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 17:05 +0200, Rafael J. Wysocki wrote:
> >  	if (pm_power_off_prepare)
> >  		pm_power_off_prepare();
> >  	sysdev_shutdown();
> > +	disable_nonboot_cpus();
> 
> Before sysdev_shutdown(), please.
> 
> sysdev_shutdown() may touch things that belong to CPU0.

Damn, you're right. Missed that.

	tglx




