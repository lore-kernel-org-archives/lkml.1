Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZIXPyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZIXPyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZIXPyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:54:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:31646 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbZIXPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:54:34 -0400
Message-ID: <4ABB9627.9040708@oracle.com>
Date: Thu, 24 Sep 2009 08:54:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: fix htmldocs pci.c
References: <1253798147.10654.3.camel@ht.satnam>
In-Reply-To: <1253798147.10654.3.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ABB95E9.014E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Fix the following htmldocs warnings:
> 
>   Warning(drivers/pci/pci.c:2552): No description found for parameter 'dev'
>   Warning(drivers/pci/pci.c:2552): No description found for parameter 'decode'
>   Warning(drivers/pci/pci.c:2552): No description found for parameter 'command_bits'
>   Warning(drivers/pci/pci.c:2552): No description found for parameter 'change_bridge'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Ack, but already sent to Jesse & linux-pci mailing list.

> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/pci/pci.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 6edecff..67288ec 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2542,10 +2542,10 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
>  
>  /**
>   * pci_set_vga_state - set VGA decode state on device and parents if requested
> - * @dev the PCI device
> - * @decode - true = enable decoding, false = disable decoding
> - * @command_bits PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
> - * @change_bridge - traverse ancestors and change bridges
> + * @dev: the PCI device
> + * @decode: true = enable decoding, false = disable decoding
> + * @command_bits: PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
> + * @change_bridge: traverse ancestors and change bridges
>   */
>  int pci_set_vga_state(struct pci_dev *dev, bool decode,
>  		      unsigned int command_bits, bool change_bridge)

