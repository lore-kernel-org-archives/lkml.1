Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZGTNTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZGTNTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZGTNTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:19:52 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1727 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZGTNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:19:51 -0400
Date: Mon, 20 Jul 2009 15:19:40 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] hwmon: Add WM835x PMIC hardware monitoring driver
Message-ID: <20090720151940.30bd38ca@hyperion.delvare>
In-Reply-To: <1248090225-16387-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248090225-16387-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 12:43:45 +0100, Mark Brown wrote:
> This driver provides reporting of the status supply voltage rails
> of the WM835x series of PMICs via the hwmon API.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This should address all the issues Jean raised:
>  - Add a brief document to the hwmon directory.
>  - Use full constant names as arguments for template macro.
>  - Use DIV_ROUND_CLOSEST()
>  - Set driver owner.
>  - Fix typos.
> 
> Thanks to Jonathan and Jean for their reviews.
> 
>  Documentation/hwmon/wm8350      |   26 +++++++
>  drivers/hwmon/Kconfig           |   10 +++
>  drivers/hwmon/Makefile          |    1 +
>  drivers/hwmon/wm8350-hwmon.c    |  151 +++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/wm8350-core.c       |    3 +
>  include/linux/mfd/wm8350/core.h |    6 ++
>  6 files changed, 197 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hwmon/wm8350
>  create mode 100644 drivers/hwmon/wm8350-hwmon.c

Good work.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
