Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZINUmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZINUmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZINUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:42:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:26157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZINUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,384,1249282800"; 
   d="scan'208";a="550493336"
Date: Mon, 14 Sep 2009 13:42:10 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Resend][PATCH 2/2] PCI PM: Return error codes from
 pci_pm_resume()
Message-ID: <20090914134210.3376e0f7@jbarnes-g45>
In-Reply-To: <200909092351.27178.rjw@sisk.pl>
References: <200909092349.59170.rjw@sisk.pl>
	<200909092351.27178.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 23:51:27 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently pci_pm_resume() always returns 0, which makes the error
> variable defined in there a bit pointless.  Make pci_pm_resume()
> return error codes obtained from drivers' callbacks.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -689,7 +689,7 @@ static int pci_pm_resume(struct device *
>  		pci_pm_reenable_device(pci_dev);
>  	}
>  
> -	return 0;
> +	return error;
>  }
>  
>  #else /* !CONFIG_SUSPEND */
> 

Applied these two, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
