Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbYEPTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbYEPTGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYEPTGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:06:25 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:33982 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYEPTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:06:24 -0400
Date: Fri, 16 May 2008 14:04:38 -0500
From: Scott Wood <scottwood@freescale.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/4] [SPI] [POWERPC] spi_mpc83xx: handles Freescale
	MPC8610 as well
Message-ID: <20080516190438.GA2758@loki.buserror.net>
References: <20080516165052.GA24196@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516165052.GA24196@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 08:50:52PM +0400, Anton Vorontsov wrote:
>  config SPI_MPC83xx
>  	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
> -	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
> +	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE || PPC_86xx) && EXPERIMENTAL

How about "depends on SPI_MASTER && FSL_SOC && EXPERIMENTAL"?

Plus, we should change the option text to something like "MPC8xxx SPI
controller".

-Scott
