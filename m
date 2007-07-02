Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXGBOO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXGBOO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXGBOOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:14:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51848 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXGBOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:14:16 -0400
Message-ID: <46890835.2050104@garzik.org>
Date: Mon, 02 Jul 2007 10:14:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: api <linuxgent@kpnplanet.nl>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>
Subject: Re: [PATCH] scsi disk help file is not complete
References: <466D9440.3080005@kpnplanet.nl> <20070611115934.9097fb04.randy.dunlap@oracle.com>
In-Reply-To: <20070611115934.9097fb04.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Mon, 11 Jun 2007 20:28:16 +0200 api wrote:
> 
>> Good day,
>> When doing make menuconfig one comes across CONFIG_BLK_DEV_SD.
>> The help file states that this is for scsi disks.NO MENTION IS MADE THAT
>> IT IS NEEDE FOR SATA DISKS AS WELL!
>> Would have saved me a lot of time if the help was up to date.
>> I hope this can be changed so others can make a kernel for sata systems
>> quicker.
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add help info for BLK_DEV_SD referring to its use in
> SATA or PATA driver configurations.
> 
> Add help text for "ATA" indicating that it probably needs
> some SCSI config symbols enabled in order to be useful.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/ata/Kconfig  |    5 +++++
>  drivers/scsi/Kconfig |    1 +
>  2 files changed, 6 insertions(+)

applied


