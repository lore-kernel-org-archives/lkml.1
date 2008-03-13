Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYCMKNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYCMKNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYCMKLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35276 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbYCMKLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:43 -0400
Date: Thu, 13 Mar 2008 10:30:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Driver core: Call device_pm_add() after
	bus_add_device() in device_add()
Message-ID: <20080313093042.GB24027@elf.ucw.cz>
References: <200803120055.25885.rjw@sisk.pl> <200803120059.39902.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120059.39902.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 00:59:38, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Include dpm_sysfs_add() into device_pm_add(), in analogy with
> device_pm_remove(), and modify device_add() to call the latter after
> bus_add_device(), to avoid situations in which the PM core may
> attempt to suspend a device the registration of which has not been
> successful.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
