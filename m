Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbZFKSq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbZFKSq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbZFKSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:45:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758382AbZFKSpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:45:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="698571540"
Date: Thu, 11 Jun 2009 11:45:16 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Mats Erik Andersson <mats.andersson@gisladisker.se>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 1/1] pci: expose SMBus on Asus notebook A6L
Message-ID: <20090611114516.6ac4ca25@jbarnes-g45>
In-Reply-To: <20090512100523.GA31131@mea.homelinux.org>
References: <20090512100523.GA31131@mea.homelinux.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 12:05:23 +0200
Mats Erik Andersson <mats.andersson@gisladisker.se> wrote:

> From: Mats Erik Andersson <mats.andersson@gisladisker.se>
> 
> Addition of one unknown subsystem identifier to the
> quirks handler for chipset i82855GM_HB on notebook
> Asus A6L. This exposes the otherwise hidden SMBus
> controller within the south bridge ICH4-M.
> 
> Signed-off-by: Mats Erik Andersson <mats.andersson@gisladisker.se>
> ---
> 
> Tried and successfully used on kernel 2.6.29 and 2.6.23.17.
> 
> --- drivers/pci/quirks.c.orig	2009-05-09 00:47:21.000000000
> +0200 +++ drivers/pci/quirks.c	2009-05-12 11:20:04.000000000
> +0200 @@ -1068,8 +1068,9 @@ static void __init asus_hides_smbus_host
>  		else if (dev->device ==
> PCI_DEVICE_ID_INTEL_82855GM_HB) switch (dev->subsystem_device) {
>  			case 0x1751: /* M2N notebook */
>  			case 0x1821: /* M5N notebook */
> +			case 0x1897: /* A6L notebook */
>  				asus_hides_smbus = 1;
>  			}
>  		else if (dev->device ==
> PCI_DEVICE_ID_INTEL_82855PM_HB) switch (dev->subsystem_device) {

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
