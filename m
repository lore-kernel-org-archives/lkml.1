Return-Path: <linux-kernel-owner+w=401wt.eu-S1763335AbXKIPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763335AbXKIPdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbXKIPdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:33:35 -0500
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:44721 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753864AbXKIPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:33:34 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 10:33:34 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6ArZzYj88b0fxx4phD1AmvJak/RIK0yZf8GJUzdD4li4QkcKOCqqTbibrbP+kwjNbE8JvTWO5qIqIz1FPRmnIyHoMT2csJGGdFJb5ufBPVHJLBvKOrgU9BRNejiFyDKYreIs6ZII//PLo97IJq3CMaGIWTWF49zY/SZcSacOMvg=;
X-YMail-OSG: 4Qj3poAVM1lU33cJCJe6U9QnBDqPyBQHyVpkv0me
Date: Fri, 9 Nov 2007 07:26:52 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [2.6 patch] always export pci_scan_single_device
To: Adrian Bunk <bunk@kernel.org>, gregkh@suse.de, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       bluesmoke-devel@lists.sourceforge.net
In-Reply-To: <20071109060202.GO26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <275575.39195.qm@web50112.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK:    Doug Thompson <dougthompson@xmission.com>

--- Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following build error with CONFIG_HOTPLUG=n:
> 
> <--  snip  -->
> 
> ...
>   MODPOST 2137 modules
> ERROR: "pci_scan_single_device" [drivers/edac/i82875p_edac.ko] undefined!
> make[2]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/pci/probe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> f80ae6568224bd5e4d2387ec162d37c8e7fd545a 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 463a5a9..de33a02 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1012,6 +1012,7 @@ struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
>  
>  	return dev;
>  }
> +EXPORT_SYMBOL(pci_scan_single_device);
>  
>  /**
>   * pci_scan_slot - scan a PCI slot on a bus for devices.
> @@ -1200,7 +1201,6 @@ EXPORT_SYMBOL(pci_add_new_bus);
>  EXPORT_SYMBOL(pci_do_scan_bus);
>  EXPORT_SYMBOL(pci_scan_slot);
>  EXPORT_SYMBOL(pci_scan_bridge);
> -EXPORT_SYMBOL(pci_scan_single_device);
>  EXPORT_SYMBOL_GPL(pci_scan_child_bus);
>  #endif
>  
> 
> 


W1DUG
