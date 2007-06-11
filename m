Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXFKUAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXFKUAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXFKUAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:00:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47885 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXFKUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:00:33 -0400
Message-ID: <466DA9DD.8080004@garzik.org>
Date: Mon, 11 Jun 2007 16:00:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Subject: Re: [patch 2/3] Expose Power Management Policy option to users
References: <20070611184146.448266229@intel.com> <20070611114820.5290a903.kristen.c.accardi@intel.com>
In-Reply-To: <20070611114820.5290a903.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> This patch will modify the scsi and ata subsystem to allow
> users to set a power management policy for the link.
> libata drivers can define a function (enable_pm) that will
> perform hardware specific actions to enable whatever power
> management policy the user sets up if the driver supports
> it.  This power management policy will be activated after
> all disks have been enumerated and intialized.
> 
> The scsi subsystem will create a new sysfs file for each
> host in /sys/class/scsi_host called "link_power_management_policy".
> This file can have 3 possible values:
> 
> Value		Meaning
> -------------------------------------------------------------------
> min_power	User wishes the link to conserve power as much as
> 		possible, even at the cost of some performance
> 
> max_performance User wants priority to be on performance, not power
> 		savings
> 
> medium_power	User wants power savings, with less performance cost
> 		than min_power (but less power savings as well).
> 
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

seems OK at first glance, though I request that ata and scsi portions be 
split into separate patches

