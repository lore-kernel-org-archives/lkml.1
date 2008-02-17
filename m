Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYBQSPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYBQSPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYBQSPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:15:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13713 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYBQSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:15:18 -0500
Date: Sun, 17 Feb 2008 10:14:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, olof@lixom.net,
       sam@ravnborg.com
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
Message-Id: <20080217101445.881c2f4b.randy.dunlap@oracle.com>
In-Reply-To: <1203250205-5103-1-git-send-email-jonas@southpole.se>
References: <1203250205-5103-1-git-send-email-jonas@southpole.se>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 13:10:05 +0100 Jonas Bonn wrote:

> The definitions of struct pci_device_id arrays should generally follow
> the same pattern across the entire kernel.  This macro defines this
> array as static const and puts it into the __devinitconst section.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  include/linux/pci.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 87195b6..487d31c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -389,6 +389,14 @@ struct pci_driver {
>  #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
>  
>  /**
> + * PCI_DEVICE_TABLE - macro used to describe a pci device table
> + * 
> + * This macro is used to create a struct pci_device_id array in a generic
> + * manner.
> + */
> +#define PCI_DEVICE_TABLE(_table) static const struct pci_device_id _table[] __devinitconst
> +
> +/**
>   * PCI_DEVICE - macro used to describe a specific pci device
>   * @vend: the 16 bit PCI Vendor ID
>   * @dev: the 16 bit PCI Device ID
> -- 

Missing kernel-doc notation for the _table parameter.  See the
parameters for PCI_DEVICE() below for an example.

---
~Randy
