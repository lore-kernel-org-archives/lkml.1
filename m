Return-Path: <linux-kernel-owner+w=401wt.eu-S934305AbZJGQcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbZJGQcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934296AbZJGQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:32:20 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:43046 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934282AbZJGQcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:32:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4ACCC273.1030308@gmail.com>
Date: Wed, 07 Oct 2009 17:31:47 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] LIS3LV02D I2C driver
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a quick heads up wrt overlapping work.

For the i2c support Kalhan Trisal has been posting patches for i2c
support for this
driver to the lm-sensors list for some time and the latest version of that
set is also pretty clean.

The changes in these two patch sets should probably be reconciled before
merging.

> These patches add I2C bus support for LIS3LV02D accelerometer driver
> and possibility to use platform configurability for
> remapping of device axes.
>
> Changes are tested on linux-omap environment.
> Applies to 2.6.32-rc1.
>
> Samu Onkalo (2):
>   LIS3LV02D: axis remap, irq and resource setup / release added to
>     platform data
>   LIS3LV02D: I2C support
>
>  drivers/hwmon/Kconfig         |   17 ++++
>  drivers/hwmon/Makefile        |    1 +
>  drivers/hwmon/lis3lv02d.h     |    1 +
>  drivers/hwmon/lis3lv02d_i2c.c |  183 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/lis3lv02d.h     |   13 +++
>  5 files changed, 215 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/lis3lv02d_i2c.c
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

