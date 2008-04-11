Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYDKP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYDKP0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbYDKP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:26:19 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:49487 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752AbYDKP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:26:17 -0400
Message-ID: <47FF7D9B.4060306@freescale.com>
Date: Fri, 11 Apr 2008 10:02:51 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Kumar Gala <galak@kernel.crashing.org>, Jean Delvare <khali@linux-fr.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: [PATCH7/7] [POWERPC] Add i2c pins to dts and board setup
References: <47FF71B1.9070907@scram.de>
In-Reply-To: <47FF71B1.9070907@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> diff --git a/arch/powerpc/boot/dts/mpc8272ads.dts b/arch/powerpc/boot/dts/mpc8272ads.dts
> index 7285ca1..7273996 100644
> --- a/arch/powerpc/boot/dts/mpc8272ads.dts
> +++ b/arch/powerpc/boot/dts/mpc8272ads.dts
> @@ -215,6 +215,16 @@
>  				linux,network-index = <1>;
>  				fsl,cpm-command = <16200300>;
>  			};
> +
> +			i2c@11860 {
> +				compatible = "fsl,mpc8248-i2c",

mpc8272-i2c

-Scott
