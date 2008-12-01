Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbYLAH6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbYLAH6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYLAH6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:58:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:14892 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYLAH6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:58:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,694,1220252400"; 
   d="scan'208";a="366549791"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Nguyen, Tom L" <tom.l.nguyen@intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Dec 2008 15:58:25 +0800
Subject: RE: [PATCH] aerdrv: fix sanity check in report_resume
Thread-Topic: [PATCH] aerdrv: fix sanity check in report_resume
Thread-Index: AclThtkAcVk0ALGKQkqVGUNRjSUwTQAAyIvA
Message-ID: <4D05DB80B95B23498C72C700BD6C2E0B023EC665@pdsmsx502.ccr.corp.intel.com>
References: <493392BA.50906@jp.fujitsu.com>
In-Reply-To: <493392BA.50906@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked.

Nice capture.

Yanmin

>>-----Original Message-----
>>From: Hidetoshi Seto [mailto:seto.hidetoshi@jp.fujitsu.com]
>>Sent: Monday, December 01, 2008 3:31 PM
>>To: linux-pci@vger.kernel.org; Nguyen, Tom L; Zhang, Yanmin
>>Cc: linux-kernel@vger.kernel.org
>>Subject: [PATCH] aerdrv: fix sanity check in report_resume
>>
>>What we have to check here before calling it is err_handler->resume.
>>It seems that this block have been copy&pasted from report_slot_reset.
>>
>>Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>>---
>> drivers/pci/pcie/aer/aerdrv_core.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>diff --git a/drivers/pci/pcie/aer/aerdrv_core.c
>>b/drivers/pci/pcie/aer/aerdrv_core.c
>>index dfc63d0..aac7006 100644
>>--- a/drivers/pci/pcie/aer/aerdrv_core.c
>>+++ b/drivers/pci/pcie/aer/aerdrv_core.c
>>@@ -252,7 +252,7 @@ static void report_resume(struct pci_dev *dev, void *data)
>>
>> 	if (!dev->driver ||
>> 		!dev->driver->err_handler ||
>>-		!dev->driver->err_handler->slot_reset)
>>+		!dev->driver->err_handler->resume)
>> 		return;
>>
>> 	err_handler = dev->driver->err_handler;
>>--
>>1.6.0
>>

