Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYE0XVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYE0XVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYE0XVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:21:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbYE0XVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:21:04 -0400
Date: Tue, 27 May 2008 16:20:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on
 PRIMEQUEST
Message-Id: <20080527162029.e549a226.akpm@linux-foundation.org>
In-Reply-To: <483667A4.9000606@jp.fujitsu.com>
References: <4816F9B9.3090609@jp.fujitsu.com>
	<4836660B.3080406@jp.fujitsu.com>
	<483667A4.9000606@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 15:43:48 +0900
Taku Izumi <izumi.taku@jp.fujitsu.com> wrote:

> This patch adds DMI info to enable OSI(Linux) on PRIMEQUEST.
> (PRIMEQUEST is ia64 machine.)
> 
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> 
> ---
>   drivers/acpi/blacklist.c |   14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> Index: linux-2.6.25.4/drivers/acpi/blacklist.c
> ===================================================================
> --- linux-2.6.25.4.orig/drivers/acpi/blacklist.c
> +++ linux-2.6.25.4/drivers/acpi/blacklist.c
> @@ -626,6 +626,20 @@ static struct dmi_system_id acpi_osi_dmi
>   		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
>   		},
>   	},
> +	/*
> +	 * Enable OSI(Linux) on Fujitsu PRIMEQUEST
> +	 *
> +	 * DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
> +	 *
> +	 */
> +	{
> +	.callback = dmi_enable_osi_linux,
> +	.ident = "Fujitsu PRIMEQUEST",
> +	.matches = {
> +		     DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
> +		     DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
> +		},
> +	},
>   	{}
>   };

It is unclear (to me) what the impact of this patch is.  Does it fix a
problem which would justify including these patches in 2.6.26?

Also, your email client is performing space-stuffing.  That is easy
enough to repair at this end (s/^ / /) but please do sort that out for
next time.  http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
should help.

Thanks.
