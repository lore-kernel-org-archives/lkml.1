Return-Path: <linux-kernel-owner+w=401wt.eu-S1764510AbYBLUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764510AbYBLUlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYBLUl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:41:26 -0500
Received: from lixom.net ([66.141.50.11]:59242 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbYBLUlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:41:25 -0500
Date: Tue, 12 Feb 2008 14:43:30 -0600
From: Olof Johansson <olof@lixom.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       Francis Moreau <francis.moro@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 5/7] dmaengine: Make DMA Engine menu visible for AVR32
	users
Message-ID: <20080212204330.GA3184@lixom.net>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com> <1202834638-9009-2-git-send-email-hskinnemoen@atmel.com> <1202834638-9009-3-git-send-email-hskinnemoen@atmel.com> <1202834638-9009-4-git-send-email-hskinnemoen@atmel.com> <1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 12, 2008 at 05:43:56PM +0100, Haavard Skinnemoen wrote:
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/dma/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 893a3f8..1a727c1 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig DMADEVICES
>  	bool "DMA Engine support"
> -	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
> +	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32

This is a slippery slope. Things should be the other way around instead,
create a HAVE_DMA_DEVICE, select it in the relevant platform code and
make DMADEVICES depend on that.

Or just let the subsystem always be available.


-Olof
