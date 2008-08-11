Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYHKRTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYHKRTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHKRSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:18:53 -0400
Received: from outbound-mail-160.bluehost.com ([67.222.39.40]:58599 "HELO
	outbound-mail-160.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751498AbYHKRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:18:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dh2N/ikLVwgpgHP1/9NLVQSZpZ/EA6j9/LJ/c8oZfNEaPuiArQjjZOE6GIuE5vpb6UlJP47BePKUgSyzZJxWttk6bQqFyeBvMi2i/ZBDoTBWxaOqwzoq7+rbJ0xu3lj6;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 2.6.26.2] pci_ids: patch for Intel Ibex Peak DeviceIDs
Date: Mon, 11 Aug 2008 10:18:43 -0700
User-Agent: KMail/1.9.9
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, khali@linux-fr.org
References: <200808081616.08158.seth.heasley@intel.com>
In-Reply-To: <200808081616.08158.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111018.44024.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 8, 2008 4:16 pm Seth Heasley wrote:
> This patch adds the Intel Ibex Peak (PCH) LPC and SMBus Controller
> DeviceIDs.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>
> --- linux-2.6.26.2/include/linux/pci_ids.h.orig 2008-08-08
> 11:07:41.000000000 -0700 +++ linux-2.6.26.2/include/linux/pci_ids.h     
> 2008-08-08 11:22:31.000000000 -0700 @@ -2385,6 +2385,9 @@
>  #define PCI_DEVICE_ID_INTEL_ICH10_3    0x3a1a
>  #define PCI_DEVICE_ID_INTEL_ICH10_4    0x3a30
>  #define PCI_DEVICE_ID_INTEL_ICH10_5    0x3a60
> +#define PCI_DEVICE_ID_INTEL_PCH_0      0x3b10
> +#define PCI_DEVICE_ID_INTEL_PCH_1      0x3b11
> +#define PCI_DEVICE_ID_INTEL_PCH_2      0x3b30
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB   0x402f
>  #define PCI_DEVICE_ID_INTEL_5400_ERR   0x4030
>  #define PCI_DEVICE_ID_INTEL_5400_FBD0  0x4035

Should PCH_2 also be added to arch/x86/pci/irq.c?  You may as well combine the 
irq.c and pci_ids.h patches into one patch too.  Care to respin against my 
for-linus branch and resubmit?

Thanks.
-- 
Jesse Barnes, Intel Open Source Technology Center
