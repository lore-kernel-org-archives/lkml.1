Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYIAP3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYIAP3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIAP2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:28:55 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26273 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYIAP2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:28:53 -0400
Date: Mon, 1 Sep 2008 09:27:34 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/4 v2] PCI: support ARI capability
Message-ID: <20080901152734.GC16796@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> Support Alternative Routing-ID Interpretation (ARI), which increases the number of functions that can be supported by a PCIe endpoint. ARI is required by SR-IOV.
> 
> PCI-SIG ARI specification can be found at http://www.pcisig.com/specifications/pciexpress/specifications/ECN-alt-rid-interpretation-070604.pdf
> 
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> Signed-off-by: Eddie Dong <eddie.dong@intel.com>
> 
> ---
>  drivers/pci/Kconfig      |    7 ++++
>  drivers/pci/Makefile     |    2 +
>  drivers/pci/ari.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/pci.h        |    8 +++++
>  drivers/pci/probe.c      |    3 ++
>  include/linux/pci.h      |   25 ++++++++++++++++
>  include/linux/pci_regs.h |   14 +++++++++
>  7 files changed, 130 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pci/ari.c
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index e1ca425..f43cc46 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -50,3 +50,10 @@ config HT_IRQ
>  	   This allows native hypertransport devices to use interrupts.
>  
>  	   If unsure say Y.
> +
> +config PCI_ARI
> +	bool "PCI ARI support"
> +	depends on PCI
> +	default n
> +	help
> +	  This enables PCI Alternative Routing-ID Interpretation.

This Kconfig help text is a little weak. Why not include the text
you've already written here:

	Support Alternative Routing-ID Interpretation (ARI), which
	increases the number of functions that can be supported by a PCIe
	endpoint. ARI is required by SR-IOV.

In the Kconfig text, you might want to expand the SR-IOV acronym
too.

Thanks.

/ac

