Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZF0L2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZF0L2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZF0L2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:28:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZF0L2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:28:25 -0400
Date: Wed, 24 Jun 2009 17:04:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Magnus Damm <damm@igel.co.jp>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
	I/O devices
Message-ID: <20090624150400.GG1784@ucw.cz>
References: <200906140023.36147.rjw@sisk.pl> <200906141158.50171.rjw@sisk.pl> <200906150057.32424.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906150057.32424.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> +2. Run-time PM Helper Functions and Device Fields
> +
> +The following helper functions are defined in drivers/base/power/runtime.c
> +and include/linux/pm_runtime.h:
> +
> +* void pm_runtime_init(struct device *dev);
> +* void pm_runtime_enable(struct device *dev);
> +* void pm_runtime_disable(struct device *dev);
> +* int pm_runtime_suspend(struct device *dev);
> +* void pm_request_suspend(struct device *dev, unsigned long delay);
> +* int pm_runtime_resume(struct device *dev);
> +* void pm_request_resume(struct device *dev);
> +* void pm_cancel_runtime_suspend(struct device *dev);
> +* void pm_cancel_runtime_resume(struct device *dev);
> +* void pm_suspend_check_children(struct device *dev, bool enable);

Those *s look confusingly like pointers. Remove them?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
