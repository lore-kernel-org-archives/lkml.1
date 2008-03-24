Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYCXP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYCXP5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYCXP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:57:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53528 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYCXP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:57:36 -0400
Date: Mon, 24 Mar 2008 16:57:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Remove destroy_suspended_device()
Message-ID: <20080324155735.GA4069@atrey.karlin.mff.cuni.cz>
References: <200803232028.25611.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803232028.25611.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> After 2.6.24 there was a plan to make the PM core acquire all device
> semaphores during a suspend/hibernation to protect itself from
> concurrent operations involving device objects.  That proved to be
> too heavy-handed and we found a better way to achieve the goal, but
> before it happened, we had introduced the functions
> device_pm_schedule_removal() and destroy_suspended_device() to allow
> drivers to "safely" destroy a suspended device and we had adapted some
> drivers to use them.  Now that these functions are no longer necessary,
> it seems reasonable to remove them and modify their users to use the
> normal device unregistration instead.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
