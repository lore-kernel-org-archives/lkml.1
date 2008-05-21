Return-Path: <linux-kernel-owner+w=401wt.eu-S935643AbYEUPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbYEUPKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbYEUPKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:10:07 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42573 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYEUPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:10:06 -0400
Date: Wed, 21 May 2008 17:09:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jochen Friedrich <jochen@scram.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux I2C <i2c@lm-sensors.org>, Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Boris Shteinbock <bshtein@yahoo.com>
Subject: Re: [PATCH] i2c: adds support for i2c bus on Freescale CPM1/CPM2 
 controllers
Message-ID: <20080521170925.67c63326@hyperion.delvare>
In-Reply-To: <20080521143307.GD4271@pengutronix.de>
References: <4833FCCA.4080707@scram.de>
	<20080521143307.GD4271@pengutronix.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 16:33:07 +0200, Wolfram Sang wrote:
> Hi Jochen,
> 
> On Wed, May 21, 2008 at 12:43:22PM +0200, Jochen Friedrich wrote:
> > This driver uses the port of 2.4 code from Vitaly Bordug
> > <vitb@kernel.crashing.org> and the actual algorithm used by the i2c
> > driver of the DBox code on cvs.tuxboc.org from Felix Domke
> > (tmbinc@gmx.net) and Gillem (htoa@gmx.net) converted to an
> > of_platform_driver. Tested on CPM1 (MPC823 on dbox2 hardware) and
> > CPM2 (MPC8272).
> > 
> > Signed-off-by: Jochen Friedrich <jochen@scram.de>
> > ---
> Works on MPC8260.
> 
> Tested-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> >  drivers/i2c/busses/Kconfig   |   10 +
> >  drivers/i2c/busses/Makefile  |    1 +
> >  drivers/i2c/busses/i2c-cpm.c |  745 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 756 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/i2c/busses/i2c-cpm.c
> > 
> > Changes since last version:
> > - fixed copy and paste bug (I2COM_MASTER -> I2COM_START)
> > - changed dev_err() to dev_dbg() for NACK
> > - changed dev_dbg() to dev_err() for Timeout
> > - added explanation for brg formular
> Typo: formula
> 
> > - added "bus-frequency" OF attribute to be able to override i2c clock
> \o/ Cool feature. Worked nicely.
> 
> > - support for numbered adapter (it was already documented in
> >   my booting-without-of patch but not yet implemented)
> > - finally changed i2c "pseudo address" 0xfe to 0x7f << 1
> > - get rid of the "fsl,cpm-i2c" name. This logic was screwed
> > - fixed the error patch for request_irq failure
>
> path instead of patch? But well, I assume typos in this section do not
> matter much anyhow as they are not imported into git. Am I right, Jean?

Yes you are.

-- 
Jean Delvare
