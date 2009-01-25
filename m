Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZAYGmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZAYGmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 01:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZAYGma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 01:42:30 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:22902 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZAYGma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 01:42:30 -0500
Message-ID: <497C09D9.50004@genesi-usa.com>
Date: Sun, 25 Jan 2009 00:42:33 -0600
From: Matt Sealey <matt@genesi-usa.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
CC: Pierre Ossman <drzeus-sdhci@drzeus.cx>, sdhci-devel@list.drzeus.cx,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Liu Dave <DaveLiu@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       linuxppc-dev@ozlabs.org, Konjin Lai <Konjin.Lai@freescale.com>,
       Ben Dooks <ben-linux@fluff.org>, Xie Xiaobo <X.Xie@freescale.com>
Subject: Re: [PATCH 10/10] mmc: Add OpenFirmware bindings for SDHCI driver
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru> <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
In-Reply-To: <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
>  
>  	  If unsure, say Y.
>  
> +config MMC_SDHCI_OF
> +	tristate "SDHCI support on OpenFirmware platforms"
> +	depends on MMC_SDHCI && PPC_OF
> +	help
> +	  This selects the OF Secure Digital Host Controller Interface.
> +	  So far there is only Freescale eSDHC controller known to exists
> +	  on OF platforms.

Nit; would probably be better English as

	This selects the OF support for Secure Digital Host Controller
	Interfaces. So far, only the Freescale eSDHC controller is known
	to exist on OF platforms.

-- Matt Sealey <matt@genesi-usa.com>
