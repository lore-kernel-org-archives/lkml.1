Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbXEYDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbXEYDQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbXEYDQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:16:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50761 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXEYDQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:16:00 -0400
Message-ID: <465654EC.9080805@garzik.org>
Date: Thu, 24 May 2007 23:15:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [patch 1/7] libata: check for AN support
References: <20070510072247.063476979@intel.com>	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>	<20070509220952.5fa34822.akpm@linux-foundation.org> <20070510100215.94c3a2ea.kristen.c.accardi@intel.com>
In-Reply-To: <20070510100215.94c3a2ea.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Check to see if an ATAPI device supports Asynchronous Notification.
> If so, enable it.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
> Andrew, I cleaned up the function header to properly comply with kernel
> doc requirements.  Other than that, this patch is the same.  

I would ask for a simple revision:  update ata_dev_set_AN() such that it 
takes a second argument 'enable'.  This boolean indicates to the 
function whether SETFEATURES_SATA_ENABLE or SETFEATURES_SATA_DISABLE 
should be passed to the device.

Otherwise than that, it's ready to merge I would say.

