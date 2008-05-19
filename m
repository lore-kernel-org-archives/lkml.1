Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbYESNTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbYESNTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYESNRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:49345 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759443AbYESNRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:07 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/23I0E79v2ePDrFsyAgmEqUvhcQOadreXMWD8K+Q
	txmvgd1vZ1b7M7
Date: Mon, 19 May 2008 15:17:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
In-Reply-To: <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
Message-ID: <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, Grant Likely wrote:

> +    However, the binding does not attempt to define the specific method for
> +    assigning chip select numbers.  Since SPI chip select configuration is
> +    flexible and non-standardized, it is left out of this binding with the
> +    assumption that board specific platform code will be used to manage
> +    chip selects.  Individual drivers can define additional properties to
> +    support describing the chip select layout.

Yes, this looks like a problem to me. This means, SPI devices will need 
two bindings - OF and platform?... Maybe define an spi_chipselect 
OF-binding?

Thanks
Guennadi
---
Guennadi Liakhovetski
