Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXGEUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXGEUH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXGEUHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:07:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:7449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXGEUHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,505,1175497200"; 
   d="scan'208";a="264874392"
Date: Thu, 5 Jul 2007 13:03:57 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, James.Bottomley@steeleye.com,
       edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
Subject: [patch 0/4] SATA power savings patches (ALPM)
Message-Id: <20070705130357.1c172b80.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
Here's the most recent patches for ALPM.  These are also located at:
http://www.kernel.org/pub/linux/kernel/people/kristen/patches/SATA/alpm

These patches implement Aggressive Link Power management for AHCI 
controllers.  This feature is described in detail in the AHCI 1.x spec.
It provides power savings of anywhere from .5-1.5 Watts depending on
the system when it is enabled.  (a graph demonstrating power savings
of this patch along with other power patches is located at 
http://www.linuxpowertop.org/results.php for your enjoyment).

This patch is changed from the previous version in that it incorporates all
the feedback I've gotten on the patches to date.  It changes the default
of the ahci driver to be max_performance rather than min_power, so userspace
will need to explicitly enable alpm via the sysfs interface when it deems
it an appropriate time to do this.  In addition, the patch was changed to
allow either HIPM or DIPM as a prerequisite for enabling ALPM, rather than 
just using HIPM.

Thanks,
Kristen
-- 
