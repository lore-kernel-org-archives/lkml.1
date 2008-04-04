Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbYDDHt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbYDDHt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYDDHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:49:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48821 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbYDDHtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:49:51 -0400
Message-ID: <47F5DD9A.1070905@garzik.org>
Date: Fri, 04 Apr 2008 03:49:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Wedgwood <cw@f00f.org>
CC: Tejun Heo <htejun@gmail.com>, Len Brown <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add 'short help text' to ATA_ACPI so it's [de]selectable.
References: <20080318220648.GA31208@puku.stupidest.org>
In-Reply-To: <20080318220648.GA31208@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wedgwood wrote:
> ATA_ACPI isn't selectable right now because it lacks 'short help
> text'.  This means it's always enabled and always enables ACPI_DOCK.
> Add text so it's now [de]selectable.
> 
> cc: Jeff Garzik <jeff@garzik.org>
> cc: Tejun Heo <htejun@gmail.com>
> cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Chris Wedgwood <cw@f00f.org>
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 25aba69..ea665c2 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -28,7 +28,7 @@ config ATA_NONSTANDARD
>         default n
> 
>  config ATA_ACPI
> -	bool
> +	bool "ATA ACPI Support"
>  	depends on ACPI && PCI
>  	select ACPI_DOCK

applied


