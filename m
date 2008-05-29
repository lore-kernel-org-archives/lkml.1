Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYE2PxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYE2PxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYE2Pw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:52:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:5615 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYE2Pw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:52:56 -0400
Date: Thu, 29 May 2008 17:52:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux I2C <i2c@lm-sensors.org>,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Boris Shteinbock <bshtein@yahoo.com>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Freescale CPM1/CPM2
 controllers
Message-ID: <20080529175226.273f9d49@hyperion.delvare>
In-Reply-To: <4834504E.6060205@scram.de>
References: <4834504E.6060205@scram.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 18:39:42 +0200, Jochen Friedrich wrote:
> This driver uses the port of 2.4 code from Vitaly Bordug
> <vitb@kernel.crashing.org> and the actual algorithm used by the i2c
> driver of the DBox code on cvs.tuxboc.org from Felix Domke
> (tmbinc@gmx.net) and Gillem (htoa@gmx.net) converted to an
> of_platform_driver. Tested on CPM1 (MPC823 on dbox2 hardware) and
> CPM2 (MPC8272).
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  drivers/i2c/busses/Kconfig   |   10 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-cpm.c |  745 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 756 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-cpm.c
> 
> Changes since last version:
> - change bus-frequency -> clock-frequency to comply to OF standard.
> 

Applied, thanks. And thanks a lot to Wolfram for the review :)

-- 
Jean Delvare
