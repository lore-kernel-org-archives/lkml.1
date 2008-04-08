Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYDHAvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYDHAvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYDHAvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:51:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:26854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYDHAvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:51:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,619,1199692800"; 
   d="scan'208";a="547313784"
Subject: Re: [PATCH] ACPI: check a return value correctly in
	acpi_power_get_context()
From: Zhao Yakui <yakui.zhao@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47F9E1E2.5020506@cn.fujitsu.com>
References: <47F9E1E2.5020506@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 Apr 2008 16:38:26 +0800
Message-Id: <1207643906.7387.0.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 16:57 +0800, Li Zefan wrote:
> We should check *resource != NULL rather than resource != NULL,
> which will be always true.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  drivers/acpi/power.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 76bf6d9..f2a76ac 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handle,
>  	}
>  
>  	*resource = acpi_driver_data(device);
> -	if (!resource)
> +	if (!*resource)
>  		return -ENODEV;
>  
>  	return 0;
agreed.


