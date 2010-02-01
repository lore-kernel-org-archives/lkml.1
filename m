Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0BATH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:07:28 -0500
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:52723 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab0BATH1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:07:27 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line formats
Date: Mon, 1 Feb 2010 20:07:24 +0100
User-Agent: KMail/1.9.9
Cc: support@areca.com.tw, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de, linux-scsi@vger.kernel.org
References: <cover.1264967493.git.joe@perches.com> <cover.1264967493.git.joe@perches.com> <m2n.s.201002011906064544@fjphome.nl>
In-reply-To: <m2n.s.201002011906064544@fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201002012007.25498.elendil@planet.nl>
X-OriginalArrivalTime: 01 Feb 2010 19:07:26.0178 (UTC) FILETIME=[CAC15420:01CAA371]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> String constants that are continued on subsequent lines with \
> are not good.
> Fix rebulid/rebuild typos
>
> Signed-off-by: Joe Perches <joe@perches.com>

Hmmm. Would it be an idea to also get rid of all the trailing spaces in the
printks, or is that for another cleanup?

If you'd prefer a separate patch, I can do it.

A few random examples:

>  drivers/scsi/arcmsr/arcmsr_hba.c |   49
> +++++++++++++++++-------------------- 1 files changed, 23 insertions(+),
> 26 deletions(-)
>
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c index 47d5d19..a0378d5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
[...]
+                       printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' timeout, retry count down = %d \n",
+                              acb->host->host_no, retry_count);
[...]
+               printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command done acb = '0x%p'"
                                "ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
                                " ccboutstandingcount = %d \n"
                                , acb->host->host_no
[...]
                printk(KERN_NOTICE
+                       "arcmsr%d: wait 'stop adapter background rebuild' timeout \n"
                        , acb->host->host_no);
[...]
+                       printk(KERN_NOTICE "arcmsr%d: 'can not set diver mode \n"
