Return-Path: <linux-kernel-owner+w=401wt.eu-S937967AbXHHTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937967AbXHHTKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXHHTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:10:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:38426 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764111AbXHHTKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:10:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,237,1183359600"; 
   d="scan'208";a="278433214"
Date: Wed, 8 Aug 2007 12:07:39 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch 0/4] Updated AN patches, now without gendisk
Message-Id: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Here is an updated set of patches that implement Asynchronous Notification
support for ATAPI devices.  In this version I no longer export the AN
capability through genhd, and the uevent is sent by the scsi_device 
instead of gendisk.  I added a generic SCSI device event mechanism so
that it can be expanded in the future with other types of events.  Please
let me know what you think.

Kristen
-- 
