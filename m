Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZAZW1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZAZW1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZAZW1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:27:35 -0500
Received: from bsdimp.com ([199.45.160.85]:56474 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZAZW1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:27:34 -0500
Date: Mon, 26 Jan 2009 15:26:20 -0700 (MST)
Message-Id: <20090126.152620.1498421823.imp@bsdimp.com>
To: matt@genesi-usa.com
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, arnd@arndb.de,
       DaveLiu@freescale.com, linux-kernel@vger.kernel.org,
       Joe.D'abbraccio@freescale.com, linuxppc-dev@ozlabs.org,
       X.Xie@freescale.com, sdhci-devel@list.drzeus.cx, drzeus-sdhci@drzeus.cx,
       Konjin.Lai@freescale.com
Subject: Re: [PATCH 10/10] mmc: Add OpenFirmware bindings for SDHCI driver
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <497C09D9.50004@genesi-usa.com>
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru>
	<20090122020041.GJ11492@oksana.dev.rtsoft.ru>
	<497C09D9.50004@genesi-usa.com>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <497C09D9.50004@genesi-usa.com>
            Matt Sealey <matt@genesi-usa.com> writes:
: Anton Vorontsov wrote:
: >  
: >  	  If unsure, say Y.
: >  
: > +config MMC_SDHCI_OF
: > +	tristate "SDHCI support on OpenFirmware platforms"
: > +	depends on MMC_SDHCI && PPC_OF
: > +	help
: > +	  This selects the OF Secure Digital Host Controller Interface.
: > +	  So far there is only Freescale eSDHC controller known to exists
: > +	  on OF platforms.
: 
: Nit; would probably be better English as
: 
: 	This selects the OF support for Secure Digital Host Controller
: 	Interfaces. So far, only the Freescale eSDHC controller is known
: 	to exist on OF platforms.

Is this the SD Association standard host controller interface, or a
custom one by Freescale?  If the former, then I'd suggest:

	This selects OF support for the SD Association standard Secure
	Digital Host Controller Interface (version x.xx).  So far,
	only the Freescale eSDHC controller is the only example on OF
	platforms.

if the latter:

	This selects OF support for Freescale's custom Secure Digital
	Host Controller Interface.  So far, only the Freescale eSDHC
	controller is the only example on OF platforms.

Warner
