Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYDKOGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYDKOGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbYDKOGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:06:31 -0400
Received: from mail0.scram.de ([78.47.204.202]:38223 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759269AbYDKOGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:06:30 -0400
X-Spam-Score: -4.219
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47FF705C.9040404@scram.de>
Date: Fri, 11 Apr 2008 16:06:20 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: [PATCH0/7] OF support for i2c bus drivers
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches implements the framework needed by of_platform_driver i2c bus drivers.
i2c-mpc is then converted to an of_platform_driver and i2c-cpm is added as new driver.

This is based on earlier work by Jon Smirl and Jean Delvare.

[PATCH1/7] i2c: Add support for device alias names
[PATCH2/7] i2c: Convert all new-style drivers to use module aliasing
[PATCH3/7] i2c: OF helpers for the i2c API
[PATCH4/7] i2c: Convert PowerPC MPC i2c to of_platform_driver from platform_driver
[PATCH5/7] i2c: Kill the old driver matching scheme
[PATCH6/7] i2c: adds support for i2c bus on Freescale CPM1/CPM2 controllers
[PATCH7/7] [POWERPC] Add i2c pins to dts and board setup

Thanks,
Jochen
