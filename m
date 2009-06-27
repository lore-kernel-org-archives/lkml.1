Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZF0VwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZF0VwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 17:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZF0Vv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 17:51:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZF0Vv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 17:51:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices
Date: Sat, 27 Jun 2009 23:52:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <200906140023.36147.rjw@sisk.pl> <200906150057.32424.rjw@sisk.pl> <20090624150400.GG1784@ucw.cz>
In-Reply-To: <20090624150400.GG1784@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200906272352.42022.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Pavel Machek wrote:
> Hi!
> 
> 
> > +2. Run-time PM Helper Functions and Device Fields
> > +
> > +The following helper functions are defined in drivers/base/power/runtime.c
> > +and include/linux/pm_runtime.h:
> > +
> > +* void pm_runtime_init(struct device *dev);
> > +* void pm_runtime_enable(struct device *dev);
> > +* void pm_runtime_disable(struct device *dev);
> > +* int pm_runtime_suspend(struct device *dev);
> > +* void pm_request_suspend(struct device *dev, unsigned long delay);
> > +* int pm_runtime_resume(struct device *dev);
> > +* void pm_request_resume(struct device *dev);
> > +* void pm_cancel_runtime_suspend(struct device *dev);
> > +* void pm_cancel_runtime_resume(struct device *dev);
> > +* void pm_suspend_check_children(struct device *dev, bool enable);
> 
> Those *s look confusingly like pointers. Remove them?

>From the doc?  OK, I can use another character. :-)

Best,
Rafael
