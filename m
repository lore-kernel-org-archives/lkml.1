Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXFKStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXFKStm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXFKStc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:49:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:62647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXFKSta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="95502683"
Date: Mon, 11 Jun 2007 11:46:00 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org, james.bottomley@steeleye.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
Subject: [patch 0/3] AHCI Link Power Management
Message-Id: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This series of patches enables Aggressive Link Power Management for AHCI 
devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
saves me a full watt of power.  On other systems, reported power savings
range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
with similar results.  Please give it a try and let me know what you think.

thanks,
Kristen

-- 
