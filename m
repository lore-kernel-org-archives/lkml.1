Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781Ab0ATDSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0ATDSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015Ab0ATDSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:18:18 -0500
Received: from kroah.org ([198.145.64.141]:38401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0ATDSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:18:17 -0500
Date: Tue, 19 Jan 2010 18:51:47 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM / Runtime: Add sysfs switch for disabling
	device run-time PM
Message-ID: <20100120025147.GA20979@kroah.com>
References: <201001180129.55219.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001180129.55219.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 01:29:55AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM
> 
> Add new device sysfs attribute, power/runtime, allowing the user
> space to block the run-time power management of the device.  If this
> attribute is set to "disabled", the driver of the device won't be
> able to enable run-time power management for it (without breaking the
> rules).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/power.h   |    4 +
>  drivers/base/power/runtime.c |  107 +++++++++++++++++++++++++++++++++----------
>  drivers/base/power/sysfs.c   |   46 ++++++++++++++++++
>  include/linux/pm.h           |    1 
>  include/linux/pm_runtime.h   |   11 +---
>  5 files changed, 139 insertions(+), 30 deletions(-)

You forgot to also add an entry into Documentation/ABI/ for when you
add/change a sysfs file :)

thanks,

greg k-h
