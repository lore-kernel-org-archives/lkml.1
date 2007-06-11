Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXFKUB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXFKUB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXFKUBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:01:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47904 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbXFKUBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:01:16 -0400
Message-ID: <466DAA09.7090000@garzik.org>
Date: Mon, 11 Jun 2007 16:01:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com, arjan@linux.intel.com
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
References: <20070611184146.448266229@intel.com> <20070611114839.907bcae2.kristen.c.accardi@intel.com>
In-Reply-To: <20070611114839.907bcae2.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> This patch will set the correct bits to turn on Aggressive
> Link Power Management (ALPM) for the ahci driver.  This
> will cause the controller and disk to negotiate a lower
> power state for the link when there is no activity (see
> the AHCI 1.x spec for details).  This feature is mutually
> exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
> is disabled.  ALPM will be enabled by default, but it is
> settable via the scsi host syfs interface.  Possible 
> settings for this feature are:
> 
> Setting		Effect
> ----------------------------------------------------------
> min_power	ALPM is enabled, and link set to enter 
> 		lowest power state (SLUMBER) when idle
> 		Hot plug not allowed.
> 
> max_performance	ALPM is disabled, Hot Plug is allowed
> 
> medium_power	ALPM is enabled, and link set to enter
> 		second lowest power state (PARTIAL) when
> 		idle.  Hot plug not allowed.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

seems OK at first glance, though I'll have questions about hardware 
behavior once I get off this day-long Intel conference call :)


