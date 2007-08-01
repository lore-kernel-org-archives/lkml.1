Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbXHAVcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbXHAVcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 17:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXHAVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 17:31:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:4897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117AbXHAVbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 17:31:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,210,1183359600"; 
   d="scan'208";a="275383927"
Date: Wed, 1 Aug 2007 14:28:37 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: james.bottomley@steeleye.com, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, arjan@linux.intel.com
Subject: [patch 0/3] Updated ALPM patches
Message-Id: <20070801142837.2dabed87.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This is an updated series of ALPM patches.  I moved all link power management
stuff out of scsi sysfs and just use the shost_addr pointer in the host
template to create the sysfs files.  This provides the same interface
as before, without requiring any scsi changes.  I also fixed a bug in
the handling of the interrupts for some devices (mostly ATAPI it seems)
which will need some bits out of Serror cleared on power state changes,
and I also modified the code slightly based on feedback from tejun.

please review,
Thanks,
Kristen

-- 
