Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYFEQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYFEQp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFEQpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:45:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:35008 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYFEQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:45:18 -0400
Message-ID: <fa686aa40806050945h5e61910flb63a8d00e1d2b0e8@mail.gmail.com>
Date: Thu, 5 Jun 2008 10:45:17 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] [RFC v3] OF: OpenFirmware bindings for the mmc_spi driver
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Jochen Friedrich" <jochen@scram.de>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Gary Jennejohn" <garyj@denx.de>,
       "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080605161624.GA517@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605161624.GA517@polina.dev.rtsoft.ru>
X-Google-Sender-Auth: b750125be8c30ab5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 10:16 AM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> Here is v3. I'm out of ideas if you won't like it. :-)
>
> v3:
> - Now these bindings are using bus notifiers chain, thus we adhere to the
>  spi bus.
>
>  By the way, this scheme (IMO) looks good for I2C devices which needs
>  platform_data extracted from the device tree too (Cc'ing Jochen).
>
> - Plus changed the OF bindings themselves, implemented voltage-range
>  property. (Pierre, please take a look at vddrange_to_ocrmask(). I
>  wonder if you would like this in the MMC core instead, with a kernel
>  doc, of course.)
>
> v2:
> - Bindings were adhered to the MMC_SPI driver. Withdrawn by Pierre Ossman.

Personally I think your v2 was better, and if I'm interpreting
Pierre's comments correctly I think his main point is that instead of
using the 'stock' probe/remove hooks for the spi mmc driver, the
driver should be mildly reworked to provide a common block of code
that can be used by both the OF and non-OF versions of the
probe/remove routines.  I also think that is the way to go.

Cheers,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
