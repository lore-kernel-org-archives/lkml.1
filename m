Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab0AOSXW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975Ab0AOSXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:23:20 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:41910 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757627Ab0AOSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:23:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kgPb2EDbDWayxHkR2riwCR1SbA7N1j4DwmtCKGUjgh+SVn/wUTCpNjfKaC+2henx8ENc8S1rPpO6RMyd8qmYJ2lLH2i1wyLacVQukkUtVOewrJBVxPtIFZhN9dQGvBtz;
Date: Fri, 15 Jan 2010 10:23:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        khali@linux-fr.org, seth.heasley@intel.com
Subject: Re: [PATCH 2.6.32.3] irq: irq and pci_ids patch for Intel Cougar
 Point DeviceIDs
Message-ID: <20100115102320.4020b5cf@jbarnes-piketon>
In-Reply-To: <201001121656.37664.seth.heasley@intel.com>
References: <201001121656.37664.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 16:56:37 -0800
Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds the Intel Cougar Point (PCH) LPC and SMBus Controller
> DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.32.3/arch/x86/pci/irq.c.orig	2010-01-06
> 15:07:45.000000000 -0800 +++ linux-2.6.32.3/arch/x86/pci/irq.c
> 2010-01-07 13:10:28.000000000 -0800 @@ -590,6 +590,8 @@
>  	case PCI_DEVICE_ID_INTEL_ICH10_1:
>  	case PCI_DEVICE_ID_INTEL_ICH10_2:
>  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> +	case PCI_DEVICE_ID_INTEL_CPT_LPC1:
> +	case PCI_DEVICE_ID_INTEL_CPT_LPC2:
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
> --- linux-2.6.32.3/include/linux/pci_ids.h.orig	2010-01-06
> 15:07:45.000000000 -0800 +++
> linux-2.6.32.3/include/linux/pci_ids.h	2010-01-07
> 13:10:28.000000000 -0800 @@ -2398,6 +2398,9 @@ #define
> PCI_DEVICE_ID_INTEL_82840_HB	0x1a21 #define
> PCI_DEVICE_ID_INTEL_82845_HB	0x1a30 #define
> PCI_DEVICE_ID_INTEL_IOAT	0x1a38 +#define
> PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22 +#define
> PCI_DEVICE_ID_INTEL_CPT_LPC1	0x1c42 +#define
> PCI_DEVICE_ID_INTEL_CPT_LPC2	0x1c43 #define
> PCI_DEVICE_ID_INTEL_82801AA_0	0x2410 #define
> PCI_DEVICE_ID_INTEL_82801AA_1	0x2411 #define
> PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
