Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbXLEUzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbXLEUzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLEUzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:55:31 -0500
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:46125 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751561AbXLEUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:55:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=a9+D8HV6bWecGyOGHLxto2071AedYDpi+oiupovLpyEmU24jQJ7HX20o25a7RqmCz3E07SR+YX644OmPmDvd009mSJtuP4FnII2+Vqci1z5Jt43dCn5QRtcFqH9jMBHwRlBDI5OR0Jiqp0FEGh7gKs1EtE54lHcfv9FdI4zMmEc=;
X-YMail-OSG: sLZu1akVM1mKB.V36zrIiP05FQU3wEQ2Np.9JeYg7B7yzTxo8tGfWgmYYQux0huCCoCDeUNA_QrVpVpTsI2WtIG_nUhuqsQ_5VU6e9AiXz.shSsw27rNwOeZECHhOjimxia_UjMJfd3na4c-
Date: Wed, 5 Dec 2007 12:55:30 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 07/20] drivers/edac/: use LIST_HEAD instead of LIST_HEAD_INIT
To: Denis Cheng <crquan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1196882353-18827-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <224182.35807.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACK: Doug Thompson <dougthompson@xmission.com>


--- Denis Cheng <crquan@gmail.com> wrote:

> single list_head variable initialized with LIST_HEAD_INIT could almost
> always can be replaced with LIST_HEAD declaration, this shrinks the code
> and looks better.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
>  drivers/edac/edac_device.c |    2 +-
>  drivers/edac/edac_mc.c     |    2 +-
>  drivers/edac/edac_pci.c    |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
> index f3690a6..6f0b522 100644
> --- a/drivers/edac/edac_device.c
> +++ b/drivers/edac/edac_device.c
> @@ -36,7 +36,7 @@
>   * is protected by the 'device_ctls_mutex' lock
>   */
>  static DEFINE_MUTEX(device_ctls_mutex);
> -static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
> +static LIST_HEAD(edac_device_list);
>  
>  #ifdef CONFIG_EDAC_DEBUG
>  static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 063a1bf..9cd778f 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -36,7 +36,7 @@
>  
>  /* lock to memory controller's control array */
>  static DEFINE_MUTEX(mem_ctls_mutex);
> -static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
> +static LIST_HEAD(mc_devices);
>  
>  #ifdef CONFIG_EDAC_DEBUG
>  
> diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
> index 5dee9f5..dabba2d 100644
> --- a/drivers/edac/edac_pci.c
> +++ b/drivers/edac/edac_pci.c
> @@ -29,7 +29,7 @@
>  #include "edac_module.h"
>  
>  static DEFINE_MUTEX(edac_pci_ctls_mutex);
> -static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
> +static LIST_HEAD(edac_pci_list);
>  
>  /*
>   * edac_pci_alloc_ctl_info
> -- 
> 1.5.3.4
> 



W1DUG
