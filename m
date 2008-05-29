Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYE2TbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYE2TbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYE2Taz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:30:55 -0400
Received: from baikonur.stro.at ([213.239.196.228]:59240 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYE2Tay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:30:54 -0400
Date: Thu, 29 May 2008 21:30:47 +0200
From: maximilian attems <max@stro.at>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smctr: use request_firmware()
Message-ID: <20080529193047.GB2129@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212068824.26088.25.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if (request_firmware(&fw, "tr_smctr.bin", &dev->dev))
> +               return (UCODE_NOT_PRESENT);

thanks a lot, please add a printk for users:
	printk(KERN_ERR "smctr: Can't load firmware file tr_smctr.bin\n")
	

-- 
maks
