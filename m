Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZFDWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZFDWws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZFDWwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:52:40 -0400
Received: from mga05.intel.com ([192.55.52.89]:6278 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbZFDWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:52:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,307,1241420400"; 
   d="scan'208";a="463657858"
Date: Fri, 5 Jun 2009 00:54:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: Re: [PATCH v3] MFD: PCAP driver
Message-ID: <20090604225447.GA4806@sortiz.org>
References: <1243399356.2263.46.camel@brutus> <10f740e80906030738x3b42de18n189367b28a730c56@mail.gmail.com> <1244074856.4767.26.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1244074856.4767.26.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, Jun 03, 2009 at 09:20:56PM -0300, Daniel Ribeiro wrote:
> Em Qua, 2009-06-03 às 16:38 +0200, Geert Uytterhoeven escreveu: 
> > > +config EZX_PCAP
> > > +       bool "PCAP Support"
> > > +       depends on SPI_MASTER
> > 
> > It also has to depend on GENERIC_HARDIRQS, as it needs set_irq_type():
> 
> Hi Geert, sorry for this. :)
> 
> 
> 
> Fix EZX_PCAP dependency
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
Thanks. Pushed to my for-next branch.
I fixed it on the original patch, to avoid having 2 commits.

Cheers,
Samuel.


> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 060ee14..6557d60 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -243,7 +243,7 @@ config PCF50633_GPIO
>  
>  config EZX_PCAP
>  	bool "PCAP Support"
> -	depends on SPI_MASTER
> +	depends on GENERIC_HARDIRQS && SPI_MASTER
>  	help
>  	  This enables the PCAP ASIC present on EZX Phones. This is
>  	  needed for MMC, TouchScreen, Sound, USB, etc..
> 
> -- 
> Daniel Ribeiro
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
