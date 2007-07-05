Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXGEVKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXGEVKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbXGEVJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:09:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:64298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbXGEVJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,505,1175497200"; 
   d="scan'208";a="264898505"
Date: Thu, 5 Jul 2007 14:06:36 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 0/3] clean gendisk out of scsi ULD structs
Message-Id: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since gendisk will now become part of struct scsi_device, we don't need
to store this value in any private data structs where they already store
scsi_device.  This series cleans up a few drivers which did this.

Kristen

-- 
