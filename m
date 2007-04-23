Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXDWTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXDWTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXDWTHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:07:09 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:33812 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbXDWTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:07:07 -0400
Date: Mon, 23 Apr 2007 14:07:00 -0500
From: Scott Wood <scottwood@freescale.com>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       linux-pcmcia@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Fw: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Message-ID: <20070423190700.GA9987@ld0162-tx32.am.freescale.net>
References: <20070422232658.5f427fd3@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422232658.5f427fd3@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 11:26:58PM +0400, Vitaly Bordug wrote:
> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
> index 90e047a..330ac91 100644
> --- a/arch/powerpc/boot/dts/mpc885ads.dts
> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> @@ -112,6 +112,18 @@
>  			compatible = "CPM";
>  		};
>  
> +               pcmcia@0080 {
> +                       linux,phandle = <0080>;
> +                       #interrupt-cells = <1>;
> +                       #size-cells = <2>;
> +                       compatible = "8xx";
> +                       device_type = "pcmcia";
> +                       reg = <80 80>;
> +                       clock-frequency = <2faf080>;
> +                       interrupt-parent = <ff000000>;
> +                       interrupts = <d 1>;
> +		};
> +

DTC supports labels now; we should be using those instead of hardcoded
phandles.  Also, please indent by tabs.

-Scott
