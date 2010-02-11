Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0BKOz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:55:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:48232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab0BKOz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:55:58 -0500
Date: Thu, 11 Feb 2010 15:55:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: devres/irq: Fix cross-referencing comments
In-Reply-To: <20100211150436.1f86e060@hyperion.delvare>
Message-ID: <alpine.LNX.2.00.1002111555000.30967@pobox.suse.cz>
References: <20100211150436.1f86e060@hyperion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Jean Delvare wrote:

> Fix the reference (in comment) from devm_request_irq to devm_free_irq
> and back.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  kernel/irq/devres.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.33-rc7.orig/kernel/irq/devres.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.33-rc7/kernel/irq/devres.c	2010-02-11 14:53:35.000000000 +0100
> @@ -42,7 +42,7 @@ static int devm_irq_match(struct device
>   *	automatically freed on driver detach.
>   *
>   *	If an IRQ allocated with this function needs to be freed
> - *	separately, dev_free_irq() must be used.
> + *	separately, devm_free_irq() must be used.
>   */
>  int devm_request_threaded_irq(struct device *dev, unsigned int irq,
>  			      irq_handler_t handler, irq_handler_t thread_fn,
> @@ -81,7 +81,7 @@ EXPORT_SYMBOL(devm_request_threaded_irq)
>   *	Except for the extra @dev argument, this function takes the
>   *	same arguments and performs the same function as free_irq().
>   *	This function instead of free_irq() should be used to manually
> - *	free IRQs allocated with dev_request_irq().
> + *	free IRQs allocated with devm_request_irq().
>   */
>  void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
>  {

Hi Jean,

the latter has already been fixed in my tree. Applied the former hunk. 
Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
