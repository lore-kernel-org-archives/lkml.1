Return-Path: <linux-kernel-owner+w=401wt.eu-S1161676AbXBOXJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161676AbXBOXJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161641AbXBOXJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:09:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60304 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161674AbXBOXJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:09:29 -0500
Message-ID: <45D4E824.1010903@garzik.org>
Date: Thu, 15 Feb 2007 18:09:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
References: <1170920422.15989.354.camel@ymzhang>	 <45CBCC31.7070909@garzik.org> <1170991791.15989.364.camel@ymzhang>
In-Reply-To: <1170991791.15989.364.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin wrote:
> On Thu, 2007-02-08 at 20:19 -0500, Jeff Garzik wrote:
>> Zhang, Yanmin wrote:
>>> If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
>>> fixed irq number. On ia64 platform, such numbers are GSI and should be converted
>>> to irq vector.
>>>
>>> Below patch against kernel 2.6.20 fixes it.
>>>
>>> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
>> IA64 should create its own libata-portmap.h, rather than modifying the 
>> one in asm-generic with arch-specific choices.
>>
>> powerpc is a current example of this (and currently the only 
>> non-asm-generic user) found in kernel 2.6.20.
> Thank Jeff. I worked out a new patch.
> 
> If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the fixed
> irq number. On ia64 platform, such numbers are GSI and should be converted to irq
> vector.
> 
> Below patch against kernel 2.6.20 fixes it.
>  
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

applied


