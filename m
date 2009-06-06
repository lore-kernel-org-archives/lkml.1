Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZFFDX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZFFDX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZFFDXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:23:20 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50291 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZFFDXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:23:20 -0400
Date: Sat, 6 Jun 2009 10:44:10 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: leon.woestenberg@gmail.com
Cc: linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Leon Woestenberg <leon@sidebranch.com>
Subject: Re: [PATCH] Add MSI interrupts to DTS of MPC8315E-RDB
Message-ID: <20090606004410.GA10940@yookeroo.seuss>
Mail-Followup-To: leon.woestenberg@gmail.com, linuxppc-dev@ozlabs.org,
	galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
	Leon Woestenberg <leon@sidebranch.com>
References: <4a292f95.05a4100a.1a14.0a04@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a292f95.05a4100a.1a14.0a04@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 07:45:41AM -0700, leon.woestenberg@gmail.com wrote:
> The PCIe MSI interrupts are missing from the device tree source, and
> thus were not enabled. This patch adds them.
> 
> Tested to work on MPC8315E-RDB with custom FPGA PCIe device.
> 
> Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
> Tested-by: Leon Woestenberg <leon@sidebranch.com>
> 
> diff --git a/arch/powerpc/boot/dts/mpc8315erdb.dts b/arch/powerpc/boot/dts/mpc8315erdb.dts
> index 3f4c5fb..4f04667 100644
> --- a/arch/powerpc/boot/dts/mpc8315erdb.dts
> +++ b/arch/powerpc/boot/dts/mpc8315erdb.dts
> @@ -322,6 +322,21 @@
>  			reg = <0x700 0x100>;
>  			device_type = "ipic";
>  		};
> +
> +		ipic-msi@7c0 {
> +			compatible = "fsl,ipic-msi";
> +                        reg = <0x7c0 0x40>;
> +                        msi-available-ranges = <0 0x100>;

This patch appears not to use consistent whitespace formatting.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
