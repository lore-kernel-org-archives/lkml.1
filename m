Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYHCMaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYHCMaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYHCMa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:30:27 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56034 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYHCMa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:30:26 -0400
Date: Sun, 3 Aug 2008 15:30:24 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Manish Katiyar <mkatiyar@gmail.com>
cc: kernel-janitors@vger.kernel.org, astarikovskiy@suse.de,
       vladimir.p.lebedev@intel.com, LKML <linux-kernel@vger.kernel.org>,
       trivial@vger.kernel.org
Subject: Re: [PATCH] Remove warning 'unused variable battery' in drivers/acpi/sbs.c
In-Reply-To: <ea11fea30808030024v18912201x46d12fe389e508f8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808031528420.31606@wrl-59.cs.helsinki.fi>
References: <ea11fea30808030024v18912201x46d12fe389e508f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Aug 2008, Manish Katiyar wrote:

> Below patch removes the following warning:
> drivers/acpi/sbs.c: In function 'acpi_battery_remove':
> drivers/acpi/sbs.c:819: warning: unused variable 'battery'
> 
> 
> 
> Signed-off-by:- "Manish Katiyar" <mkatiyar@gmail.com>
> 
> ---
>  drivers/acpi/sbs.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
> index 10a3651..8493603 100644
> --- a/drivers/acpi/sbs.c
> +++ b/drivers/acpi/sbs.c
> @@ -816,7 +816,9 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
> 
>  static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
>  {
> +#ifdef CONFIG_ACPI_SYSFS_POWER || CONFIG_ACPI_PROCFS_POWER

I don't think you can use || operator in ifdef like that... ...Try
#if defined(...) || (...) instead.


-- 
 i.
