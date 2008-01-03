Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYACMfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYACMfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 07:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYACMe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 07:34:57 -0500
Received: from neopsis.com ([213.239.204.14]:59201 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881AbYACMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 07:34:57 -0500
Message-ID: <477CD665.9050102@dbservice.com>
Date: Thu, 03 Jan 2008 13:34:45 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071216)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Andy Whitcroft <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
References: <20071202130335.690a8daf@cw05lap>
In-Reply-To: <20071202130335.690a8daf@cw05lap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.245, required 5, AWL 0.25, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> By the way, what is the consensus on lines over 80 characters?
> checkpatch complains about the following:
> 
> WARNING: line over 80 characters
> #762: FILE: drivers/spi/spi_s3c24xx_dma.c:720:
> +       printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav Technologies AB\n");
> 
> I can of course break this into:
> 
>         printk(KERN_INFO "S3C24xx SPI DMA driver (c) 2007 Nordnav "
> 	       "Technologies AB\n");
> 
> but in my opinion that becomes more even unreadable.  Would it be
> possible to add a special case so that checkpatch ignores long strings
> that go beyond 80 characters?  Do you think it is a good idea?

At the top of the file add a #define and use that in the code? Some 
drivers define their version/author etc that way and then just
printk(DRIVER_VERSION DRIVER_AUTHOR);

tom
