Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbYCMKNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbYCMKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYCMKLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35275 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYCMKLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:43 -0400
Date: Thu, 13 Mar 2008 10:31:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 3/3] PM: make wakeup flags available whenever CONFIG_PM
	is set
Message-ID: <20080313093128.GC24027@elf.ucw.cz>
References: <200803120055.25885.rjw@sisk.pl> <200803120101.48805.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120101.48805.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 01:01:47, Rafael J. Wysocki wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> The various wakeup flags and their accessor macros in struct
> dev_pm_info should be available whenever CONFIG_PM is enabled, not
> just when CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always
> be configurable for runtime power management.  This patch (as1056)
> fixes the oversight.
> 
> [rjw: rebased the patch on top of the previous two.]
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: David Brownell <david-b@pacbell.net>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK. But I wonder if we should reduce ammount of config options we
have in power management. All those combinations are hard to test...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
