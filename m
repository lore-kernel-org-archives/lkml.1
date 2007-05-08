Return-Path: <linux-kernel-owner+w=401wt.eu-S968251AbXEHOg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968251AbXEHOg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968233AbXEHOg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:36:56 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:36533 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967027AbXEHOgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:36:55 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Date: Tue, 8 May 2007 07:36:48 -0700
Message-ID: <AF0367BA48C55940A43CCF08DF35553C012AA475@az33exm24.fsl.freescale.net>
In-Reply-To: <20070508052723.18404.8216.stgit@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Thread-Index: AceRMaeu/CQSTGDDT72fsFPMJRO8BwATGfMg
References: <20070508052723.18404.8216.stgit@localhost.localdomain>
From: "Loeliger Jon-LOELIGER" <jdl@freescale.com>
To: "Vitaly Bordug" <vitb@kernel.crashing.org>,
       "Samuel Ortiz" <samuel@sortiz.org>
Cc: "Andrew Morton" <akpm@osdl.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Adds support of IRDA transceiver residing on PowerQUICC processors and
> enabling such on mpc885ads reference board. The driver is implemented 
> using of_device concept, hereby implies arch/powerpc support 
> of the target.
> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts 
> b/arch/powerpc/boot/dts/mpc885ads.dts
> index 110bf61..95b280c 100644
> --- a/arch/powerpc/boot/dts/mpc885ads.dts
> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> @@ -178,6 +178,16 @@
>  				interrupt-parent = <930>;
>  				phy-handle = <e8002>;
>  			};
> +
> +			scc@a20 {
> +				device_type = "network";
> +				compatible = "fsl,irda";
> +				model = "SCC";
> +				device-id = <2>;
> +				reg = <a20 18 3d00 80>;
> +				interrupts = <1d 3>;
> +				interrupt-parent = <930>;
> +			};
>  		};
>  	};
>  };


Any chance we could get an update to the booting-without-of.txt
for any of this?

Thanks,
jdl
