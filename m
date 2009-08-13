Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZHMK5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZHMK5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZHMK5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:57:09 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57257 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZHMK5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fOu8nK8z/EzgeSY5MV4TwjOoM+xelBk0UojA4KKozYt2kfYNNgTqRSPccC/QeKrie4
         DPcZhHX73GfhZvwRP98++I3GCzMUBZTxsWV5/G+3PUIsBZgywdwdyi7JDilwXpLFfbU/
         ZxlDCkhSWvp2zfHq5eeiGE0DgMJOK0IEHFrww=
Subject: Re: [PATCH 5/5] [regulator] Add a Freescale MC13783 regulator
 driver
From: Liam Girdwood <lrg@kernel.org>
To: Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1250089531-10399-6-git-send-email-s.hauer@pengutronix.de>
References: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-2-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-3-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-4-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-5-git-send-email-s.hauer@pengutronix.de>
	 <1250089531-10399-6-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 11:57:06 +0100
Message-Id: <1250161026.6407.119.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 17:05 +0200, Sascha Hauer wrote:
> This driver provides basic support for the voltage regulators
> integrated into the Freescale MC13783 PMIC. It is currently
> only possible to enable/disable outputs, not to actually
> set the voltage.
> 
> changes since v1:
> 
> - decrease verbosity
> - use subsys_initcall instead of module_init
> - use platform_driver_probe instead of platform_driver_register
> - add __devexit_p to mc13783_regulator_remove
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> ---
>  drivers/regulator/Kconfig   |    8 +
>  drivers/regulator/Makefile  |    1 +
>  drivers/regulator/mc13783.c |  410 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 419 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/mc13783.c
> 

Sascha, I'm happy for this to go via Samuel's mfd tree as it makes life
easier for linux-next and merging.

Samuel, this ok with you ?

Thanks

Liam

