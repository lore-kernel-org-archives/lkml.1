Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbYEMFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbYEMFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 01:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYEMFQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 01:16:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49351 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbYEMFQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 01:16:14 -0400
Message-ID: <48292419.6010302@garzik.org>
Date: Tue, 13 May 2008 01:16:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       tklein@de.ibm.com
Subject: Re: [PATCH 1/3] [2.6.26] memory: Introduce exports for memory notifiers
References: <200805071443.02145.hannes.hering@linux.vnet.ibm.com>
In-Reply-To: <200805071443.02145.hannes.hering@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.8 (---)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-3.8 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering wrote:
> This patch introduces two exports to allow modules to use memory notifiers.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> ---
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 8ce6de5..937e825 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -53,11 +53,13 @@ int register_memory_notifier(struct notifier_block *nb)
>  {
>          return blocking_notifier_chain_register(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(register_memory_notifier);
>  
>  void unregister_memory_notifier(struct notifier_block *nb)
>  {
>          blocking_notifier_chain_unregister(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(unregister_memory_notifier);

applied 1-3


