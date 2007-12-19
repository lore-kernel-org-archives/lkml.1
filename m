Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXLSAzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXLSAzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXLSAzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:55:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:64561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbXLSAzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:55:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,182,1196668800"; 
   d="scan'208";a="448384178"
Date: Wed, 19 Dec 2007 08:54:08 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: Miguel Bot??n <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix typo in
	'drivers/net/wireless/iwlwifi/Kconfig'
Message-ID: <20071219005408.GA21768@mail.intel.com>
Reply-To: yi.zhu@intel.com
References: <200712181736.13130.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712181736.13130.mboton@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:36:12PM +0100, Miguel Bot??n wrote:
>  config IWL4965_SPECTRUM_MEASUREMENT
> -	bool "Enable Spectrum Measurement in iw4965 driver"
> +	bool "Enable Spectrum Measurement in iwl4965 driver"
>  	depends on IWL4965
>  	---help---
>  	  This option will enable spectrum measurement for the iwl4965 driver.

Thanks, but there is another one.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index c91e5f9..66ca942 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -31,7 +31,7 @@ config IWL4965_QOS
 	depends on IWL4965
 	---help---
 	  This option will enable wireless quality of service (QoS) for the
-	  iw4965 driver.
+	  iwl4965 driver.
 
 config IWL4965_HT
 	bool "Enable 802.11n HT features in iwl4965 driver"
@@ -43,7 +43,7 @@ config IWL4965_HT
 	  for the iwl4965 driver.
 
 config IWL4965_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iw4965 driver"
+	bool "Enable Spectrum Measurement in iwl4965 driver"
 	depends on IWL4965
 	---help---
 	  This option will enable spectrum measurement for the iwl4965 driver.
