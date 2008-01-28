Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYA1ROC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYA1ROC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbYA1RNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:13:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:57055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYA1RNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:13:52 -0500
Cc: Scott Wood <scottwood@freescale.com>, Jean Delvare <khali@linux-fr.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>
Message-Id: <24C74143-9A67-4B14-AE70-C02B7C892E47@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <479A185D.6010406@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCHv3 2.6.25] i2c: adds support for i2c bus on Freescale CPM1/CPM2 controllers
Date: Mon, 28 Jan 2008 11:01:46 -0600
References: <479A185D.6010406@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25, 2008, at 11:11 AM, Jochen Friedrich wrote:

> Using the port of 2.4 code from Vitaly Bordug <vitb@kernel.crashing.org 
> >
> and the actual algorithm used by the i2c driver of the DBox code on
> cvs.tuxboc.org from Tmbinc, Gillem (htoa@gmx.net). Renamed i2c-rpx.c  
> and
> i2c-algo-8xx.c to i2c-cpm.c and converted the driver to an
> of_platform_driver.
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
> arch/powerpc/boot/dts/mpc8272ads.dts         |   10 +
> arch/powerpc/boot/dts/mpc866ads.dts          |   10 +
> arch/powerpc/boot/dts/mpc885ads.dts          |   10 +
> arch/powerpc/platforms/8xx/mpc885ads_setup.c |    5 +
> drivers/i2c/busses/Kconfig                   |   10 +
> drivers/i2c/busses/Makefile                  |    1 +
> drivers/i2c/busses/i2c-cpm.c                 |  759 +++++++++++++++++ 
> +++++++++
> 7 files changed, 805 insertions(+), 0 deletions(-)

really should be split in two patches.  The drivers/i2c/* should go  
via the i2c maintainers.  the arch/powerpc via me or vitaly.

- k

