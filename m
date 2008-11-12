Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbYKLGho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbYKLGho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYKLGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:37:31 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:64618 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYKLGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:37:29 -0500
Date: Wed, 12 Nov 2008 01:37:26 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Fix argument type for acpi_evaluate_integer in
 acpi_get_physical_pci_device
In-reply-to: <200811031216.15690.arvidjaar@mail.ru>
X-X-Sender: lenb@localhost.localdomain
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0811120137070.3828@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200811031216.15690.arvidjaar@mail.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unclear what kernel this is supposed to apply to.

On Mon, 3 Nov 2008, Andrey Borzenkov wrote:

> Subject: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_get_physical_pci_device
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> CC      drivers/acpi/glue.o
> /home/bor/src/linux-git/drivers/acpi/glue.c: In function 'acpi_get_physical_pci_device':
> /home/bor/src/linux-git/drivers/acpi/glue.c:157: warning: passing argument 4 of 'acpi_evaluate_integer' from incompatible pointer type
> 
> acpi_evaluate_integer takes pointer to unsigned long long as fourth argument
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
>  drivers/acpi/glue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 98c9c76..436c8a3 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -150,7 +150,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
>  struct device *acpi_get_physical_pci_device(acpi_handle handle)
>  {
>  	struct device *dev;
> -	long device_id;
> +	unsigned long long device_id;
>  	acpi_status status;
>  
>  	status =
> 
