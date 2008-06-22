Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYFVOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYFVOrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYFVOrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:47:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45604 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYFVOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:47:02 -0400
Date: Sun, 22 Jun 2008 15:46:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [PATCH resend] arm: export dma_sync_sg_for_device (fix build failure)
Message-ID: <20080622144644.GA21340@flint.arm.linux.org.uk>
References: <tkrat.f4459fea282b5e69@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.f4459fea282b5e69@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 04:13:52PM +0200, Stefan Richter wrote:
> Date: 2006-06-18 03:49:35 +0200
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: arm: add EXPORT_SYMBOL(dma_sync_sg_for_device)
> 
> as it is for example needed by drivers/ieee1394/dma.c
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  arch/arm/common/dmabounce.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/arch/arm/common/dmabounce.c
> +++ b/arch/arm/common/dmabounce.c
> @@ -651,6 +651,7 @@ EXPORT_SYMBOL(dma_unmap_sg);
>  EXPORT_SYMBOL(dma_sync_single_for_cpu);
>  EXPORT_SYMBOL(dma_sync_single_for_device);
>  EXPORT_SYMBOL(dma_sync_sg);
> +EXPORT_SYMBOL(dma_sync_sg_for_device);
>  EXPORT_SYMBOL(dmabounce_register_dev);
>  EXPORT_SYMBOL(dmabounce_unregister_dev);

I've just committed a better fix.  That dma_sync_sg export should be a
dma_sync_sg_for_cpu.  Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
