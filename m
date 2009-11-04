Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZKDNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZKDNGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZKDNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:06:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZKDNGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:06:18 -0500
Date: Wed, 4 Nov 2009 14:06:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Liuweni <qingshenlwy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       qingshenlwy <qingshenlwy@tom.com>, xgr178 <xgr178@163.com>
Subject: Re: [PATCH]kernel/irq/chip.c:Modify the code note
In-Reply-To: <200911042011027500109@gmail.com>
Message-ID: <alpine.LRH.2.00.0911041404500.31913@twin.jikos.cz>
References: <200911042011027500109@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009, Liuweni wrote:

> In the origin, the code notes are not fit for set_irq_msi. 
> The function name is set_irq_data.
> 
> And, I change function note "handle_percpu_IRQ" to "handle_percpu_irq".
> 
> 
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> 
> ------------------------------------------
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c166019..ba566c2 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -166,11 +166,11 @@ int set_irq_data(unsigned int irq, void *data)
>  EXPORT_SYMBOL(set_irq_data);
>  
>  /**
> - *	set_irq_data - set irq type data for an irq
> + *	set_irq_msi - set MSI descriptor data for an irq
>   *	@irq:	Interrupt number
>   *	@entry:	Pointer to MSI descriptor data
>   *
> - *	Set the hardware irq controller data for an irq
> + *	Set the MSI descriptor entry for an irq
>   */

You have submitted this hunk separately before, and I already have it in 
my queue (and I have sent you a mail informing you about this being 
merged), so you'd better not include it as part of any further patch 
submissions.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

