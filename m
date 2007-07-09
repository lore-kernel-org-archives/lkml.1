Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXGIR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXGIR5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbXGIR5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:57:07 -0400
Received: from mail.tmr.com ([64.65.253.246]:34966 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbXGIR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:57:04 -0400
Message-ID: <469277D3.2020403@tmr.com>
Date: Mon, 09 Jul 2007 14:00:51 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, James.Bottomley@steeleye.com,
       edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: Re: [patch 0/4] SATA power savings patches (ALPM)
References: <20070705130357.1c172b80.kristen.c.accardi@intel.com>
In-Reply-To: <20070705130357.1c172b80.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Hi Jeff,
> Here's the most recent patches for ALPM.  These are also located at:
> http://www.kernel.org/pub/linux/kernel/people/kristen/patches/SATA/alpm
> 
> These patches implement Aggressive Link Power management for AHCI 
> controllers.  This feature is described in detail in the AHCI 1.x spec.
> It provides power savings of anywhere from .5-1.5 Watts depending on
> the system when it is enabled.  (a graph demonstrating power savings
> of this patch along with other power patches is located at 
> http://www.linuxpowertop.org/results.php for your enjoyment).
> 
> This patch is changed from the previous version in that it incorporates all
> the feedback I've gotten on the patches to date.  It changes the default
> of the ahci driver to be max_performance rather than min_power, so userspace
> will need to explicitly enable alpm via the sysfs interface when it deems
> it an appropriate time to do this.  In addition, the patch was changed to
> allow either HIPM or DIPM as a prerequisite for enabling ALPM, rather than 
> just using HIPM.
> 
I suspect these changes would be useful for servers as well, extending 
run time when a failover to UPS is detected.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
