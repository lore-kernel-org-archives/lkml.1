Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZFRKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZFRKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbZFRKyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:54:03 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38158 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbZFRKyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:54:03 -0400
Subject: Re: [PATCH] regulator: Allow consumer supplies to be set up with
 dev_name()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 11:54:03 +0100
Message-Id: <1245322443.21421.254.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 17:56 +0100, Mark Brown wrote:
> Follow the approach suggested by Russell King and implemented by him in
> the clkdev API and allow consumer device supply mapings to be set up
> using the dev_name() for the consumer instead of the struct device.
> In order to avoid making existing machines instabuggy and creating merge
> issues the use of struct device is still supported for the time being.
> 

We should probably mark this as deprecated in the docs.

> This resolves problems working with buses such as I2C which make the
> struct device available late providing that the final device name is
> known, which is the case for most embedded systems with fixed setups.
> 
> Consumers must still use the struct device when calling regulator_get().
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> For the avoidance of doubt this is most definately 2.6.32 material, not
> 2.6.31.
> 
>  drivers/regulator/core.c          |   62 ++++++++++++++++++++++++++++--------
>  include/linux/regulator/machine.h |    7 +++-
>  2 files changed, 54 insertions(+), 15 deletions(-)
> 

Applied.

Thanks

Liam

