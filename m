Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZDFOPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZDFOPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZDFOPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:15:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:54097 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZDFOPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:15:22 -0400
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <6758B03E-2525-4754-83FA-643CED277CC6@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090404192802.GA12183@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 1/3] spi_mpc83xx: Handles other Freescale processors
Date: Mon, 6 Apr 2009 09:13:51 -0500
References: <20090404192802.GA12183@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 4, 2009, at 2:28 PM, Anton Vorontsov wrote:

> With this patch we'll able to select spi_mpc83xx driver on the MPC86xx
> platforms. Let the driver depend on FSL_SOC, so we don't have to worry
> about Kconfig anymore.
>
> Also remove the "experimental" dependency, the driver has been tested
> to work on a various hardware, and surely not experimental anymore.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> drivers/spi/Kconfig |   14 ++++++--------
> 1 files changed, 6 insertions(+), 8 deletions(-)

this looks fine, but why don't we go ahead and rename things as well?   
SPI_MPC83xx -> SPI_MPC8xxx, spi_mpc83xx.c -> spi_mpc8xxx.c

- k
