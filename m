Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZBOUox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZBOUox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBOUoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:44:44 -0500
Received: from xenotime.net ([72.52.64.118]:52328 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751660AbZBOUoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:44:44 -0500
Date: Sun, 15 Feb 2009 12:45:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : kernel/irq/devres.c:fix kernel-doc
Message-Id: <20090215124525.db0a1f65.rdunlap@xenotime.net>
In-Reply-To: <499160b0.0e1b6e0a.4589.6461@mx.google.com>
References: <499160b0.0e1b6e0a.4589.6461@mx.google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 19:10:37 +0800 Qinghuang Feng wrote:

> Fix a typo, change dev_{free|request}_irq to devm_{free|request}_irq.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
> index 38a25b8..30b17de 100644
> --- a/kernel/irq/devres.c
> +++ b/kernel/irq/devres.c
> @@ -40,7 +40,7 @@ static int devm_irq_match(struct device *dev, void *res, void *data)
>   *	automatically freed on driver detach.
>   *
>   *	If an IRQ allocated with this function needs to be freed
> - *	separately, dev_free_irq() must be used.
> + *	separately, devm_free_irq() must be used.
>   */
>  int devm_request_irq(struct device *dev, unsigned int irq,
>  		     irq_handler_t handler, unsigned long irqflags,
> @@ -77,7 +77,7 @@ EXPORT_SYMBOL(devm_request_irq);
>   *	Except for the extra @dev argument, this function takes the
>   *	same arguments and performs the same function as free_irq().
>   *	This function instead of free_irq() should be used to manually
> - *	free IRQs allocated with dev_request_irq().
> + *	free IRQs allocated with devm_request_irq().
>   */
>  void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
>  {
> 

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

---
~Randy
