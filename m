Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbYA1Q6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbYA1Q6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761047AbYA1Q6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:58:15 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:41443 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYA1Q6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:58:14 -0500
Date: Mon, 28 Jan 2008 10:49:15 -0600
From: Scott Wood <scottwood@freescale.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCHv3 2.6.25] i2c: adds support for i2c bus on Freescale
	CPM1/CPM2 controllers
Message-ID: <20080128164915.GA3983@loki.buserror.net>
References: <479A185D.6010406@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A185D.6010406@scram.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 06:11:57PM +0100, Jochen Friedrich wrote:
> diff --git a/arch/powerpc/boot/dts/mpc866ads.dts b/arch/powerpc/boot/dts/mpc866ads.dts
> index daf9433..80c08bf 100644
> --- a/arch/powerpc/boot/dts/mpc866ads.dts
> +++ b/arch/powerpc/boot/dts/mpc866ads.dts
> @@ -169,6 +169,16 @@
>  				fsl,cpm-command = <0000>;
>  				linux,network-index = <1>;
>  			};
> +
> +			i2c@860 {
> +				compatible = "fsl,mpc866-i2c",
> +					     "fsl,cpm1-i2c",
> +					     "fsl,cpm-i2c";
> +				reg = <860 20 3c80 30>;
> +				interrupts = <10 3>;
> +				interrupt-parent = <&Cpm_pic>;

The label is &CPM_PIC in the current mpc866ads.dts.

-Scott
