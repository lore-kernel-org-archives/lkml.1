Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZGGIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZGGIAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZGGIAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:00:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:49445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZGGIAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:00:33 -0400
Date: Tue, 7 Jul 2009 10:00:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Trivial: Fix typo "for for"
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11131@dbde02.ent.ti.com>
Message-ID: <alpine.LNX.2.00.0907071000160.4994@wotan.suse.de>
References: <5A47E75E594F054BAF48C5E4FC4B92AB0305C11131@dbde02.ent.ti.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Gadiyar, Anand wrote:

> From: Anand Gadiyar <gadiyar@ti.com>
> 
> Trivial: Fix typo "for for"
> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> ---
>  drivers/usb/host/ehci-pci.c |    2 +-
>  drivers/usb/host/ehci.h     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-omap-2.6/drivers/usb/host/ehci-pci.c
> ===================================================================
> --- linux-omap-2.6.orig/drivers/usb/host/ehci-pci.c
> +++ linux-omap-2.6/drivers/usb/host/ehci-pci.c
> @@ -242,7 +242,7 @@ static int ehci_pci_setup(struct usb_hcd
>  	 * System suspend currently expects to be able to suspend the entire
>  	 * device tree, device-at-a-time.  If we failed selective suspend
>  	 * reports, system suspend would fail; so the root hub code must claim
> -	 * success.  That's lying to usbcore, and it matters for for runtime
> +	 * success.  That's lying to usbcore, and it matters for runtime
>  	 * PM scenarios with selective suspend and remote wakeup...
>  	 */
>  	if (ehci->no_selective_suspend && device_can_wakeup(&pdev->dev))
> Index: linux-omap-2.6/drivers/usb/host/ehci.h
> ===================================================================
> --- linux-omap-2.6.orig/drivers/usb/host/ehci.h
> +++ linux-omap-2.6/drivers/usb/host/ehci.h
> @@ -37,7 +37,7 @@ typedef __u16 __bitwise __hc16;
>  #define __hc16	__le16
>  #endif
>  
> -/* statistics can be kept for for tuning/monitoring */
> +/* statistics can be kept for tuning/monitoring */
>  struct ehci_stats {
>  	/* irq usage */
>  	unsigned long		normal;

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs
