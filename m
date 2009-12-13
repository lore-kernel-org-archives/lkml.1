Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZLMXPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZLMXPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbZLMXPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:15:40 -0500
Received: from xenotime.net ([72.52.64.118]:41196 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754668AbZLMXPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:15:40 -0500
Date: Sun, 13 Dec 2009 15:15:45 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a typo in drivers/acpi/battery.c
Message-Id: <20091213151545.4ac17532.rdunlap@xenotime.net>
In-Reply-To: <1260744536-20762-2-git-send-email-justinmattock@gmail.com>
References: <1260744536-20762-1-git-send-email-justinmattock@gmail.com>
	<1260744536-20762-2-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Dec 2009 14:48:56 -0800 Justin P. Mattock wrote:

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> ---
>  drivers/acpi/battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 3f4602b..cada73f 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -831,7 +831,7 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
>  					dev_name(&device->dev), event,
>  					acpi_battery_present(battery));
>  #ifdef CONFIG_ACPI_SYSFS_POWER
> -	/* acpi_batter_update could remove power_supply object */
> +	/* acpi_battery_update could remove power_supply object */
>  	if (battery->bat.dev)
>  		kobject_uevent(&battery->bat.dev->kobj, KOBJ_CHANGE);
>  #endif
> -- 

Hi,

You don't need an intro patch email and then the patch email
for such a simple patch.

Also, please note (from "MAINTAINERS" or from scripts/get_maintainer.pl)
that acpi patches go to linux-acpi@vger.kernel.org .

---
~Randy
