Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYCAS06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYCAS06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYCAS0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:26:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:43593 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYCAS0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:26:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=r61K89E4gEWhKuKMeokvDvkrWJObEBc+TAdMV3xOcPKQ7Xh9qltQKVEaZTjSDdEfSdDerS5zw3iLDeTJJgtMJ+Ld7yEnwCvKF/UM5R+p/FQAvU0vxb83Ei+0zwDjJlS33DtXVajmbm6OWi9sfmlSw2cbCpS4kx8ZJDLOGqsKHWc=
Message-ID: <47C99FE1.8080206@gmail.com>
Date: Sat, 01 Mar 2008 21:26:41 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
References: <20080301161902.GN25835@cs181133002.pp.htv.fi>
In-Reply-To: <20080301161902.GN25835@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May I keep them inline?

Thanks,
Alex.
Adrian Bunk wrote:
> This patch makes the following functions static instead of global inline:
> - acpi_battery_present()
> - acpi_battery_units()
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
>  drivers/acpi/battery.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> 9cfc2b0a3162d8e2f23537faefb6937c97513f38 foobar
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index f6215e8..d941c5a 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -116,7 +116,7 @@ struct acpi_battery {
>  
>  #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
>  
> -inline int acpi_battery_present(struct acpi_battery *battery)
> +static int acpi_battery_present(struct acpi_battery *battery)
>  {
>  	return battery->device->status.battery_present;
>  }
> @@ -235,7 +235,7 @@ static enum power_supply_property energy_battery_props[] = {
>  #endif
>  
>  #ifdef CONFIG_ACPI_PROCFS_POWER
> -inline char *acpi_battery_units(struct acpi_battery *battery)
> +static char *acpi_battery_units(struct acpi_battery *battery)
>  {
>  	return (battery->power_unit)?"mA":"mW";
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

