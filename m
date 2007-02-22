Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXBVWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXBVWSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXBVWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:18:53 -0500
Received: from userbg049.dsl.pipex.com ([62.190.246.49]:1169 "EHLO
	homer.intra.qzxyz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbXBVWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:18:52 -0500
X-Greylist: delayed 1497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Feb 2007 17:18:52 EST
Message-ID: <45DE1014.8060309@talk21.com>
Date: Thu, 22 Feb 2007 21:50:12 +0000
From: scott.ashcroft@talk21.com
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
CC: akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, gregkh@novell.com, hch@infradead.org
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
In-Reply-To: <20070222213845.GA14162@beardog.cca.cpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Miller (OS Dev) wrote:
> +	if (return_code = IO_OK) {

Shouldn't that be ==

> +		printk(KERN_WARNING "Completed cache flush on controller %d\n", i);
> +	} else {
> +		printk(KERN_WARNING "Error Flushing cache on controller %d\n", i);
>  	}
>  	free_irq(hba[i]->intr[2], hba[i]);

