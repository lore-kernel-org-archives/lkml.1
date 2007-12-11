Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXLKXeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXLKXeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXLKXe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:34:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:28700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXLKXeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:34:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,154,1196668800"; 
   d="scan'208";a="234889000"
Message-ID: <475F1DEE.4080909@intel.com>
Date: Tue, 11 Dec 2007 15:31:58 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jeff@garzik.org
CC: mm-commits@vger.kernel.org, randy.dunlap@oracle.com,
       auke-jan.h.kok@intel.com
Subject: Re: + e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
 added to -mm tree
References: <200712112328.lBBNSUN6014553@imap1.linux-foundation.org>
In-Reply-To: <200712112328.lBBNSUN6014553@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2007 23:32:29.0520 (UTC) FILETIME=[18707D00:01C83C4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      e1000e: make E1000E default to the same kconfig setting as E1000
> has been added to the -mm tree.  Its filename is
>      e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: e1000e: make E1000E default to the same kconfig setting as E1000
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make E1000E default to the same kconfig setting as E1000.  So people's
> machiens don't stop working when they use oldconfig.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jeff Garzik <jeff@garzik.org>
> Cc: Auke Kok <auke-jan.h.kok@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/net/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000 drivers/net/Kconfig
> --- a/drivers/net/Kconfig~e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000
> +++ a/drivers/net/Kconfig
> @@ -1986,6 +1986,7 @@ config E1000_DISABLE_PACKET_SPLIT
>  config E1000E
>  	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
>  	depends on PCI
> +	default E1000
>  	---help---
>  	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit
>  	  ethernet family of adapters. For PCI or PCI-X e1000 adapters,

Acked-by: Auke Kok <auke-jan.h.kok@intel.com>

Jeff, can you apply to #upstream?

Auke
