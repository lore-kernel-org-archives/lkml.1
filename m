Return-Path: <linux-kernel-owner+w=401wt.eu-S933542AbYBMWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbYBMWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765048AbYBMWQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:16:40 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:7792 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764473AbYBMWQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:16:37 -0500
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47B36C3B.9060508@tremplin-utc.net>
Date: Wed, 13 Feb 2008 23:16:27 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.9) Gecko/20080211 Mandriva/2.0.0.9-6mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make acpi_no_initrd_override_setup() static
References: <20080213213000.GS3383@cs181133002.pp.htv.fi>
In-Reply-To: <20080213213000.GS3383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

13/02/08 22:30, Adrian Bunk wrote/a écrit:
> acpi_no_initrd_override_setup() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Oh, indeed, no one else uses this function.
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

> 
> ---
> 1778953a9751288a9bee1d4f6a8b4f3d22e37f52 diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 0c37c65..b72a7f1 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -419,7 +419,7 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
>  }
>  
>  #ifdef CONFIG_ACPI_CUSTOM_DSDT_INITRD
> -int __init acpi_no_initrd_override_setup(char *s)
> +static int __init acpi_no_initrd_override_setup(char *s)
>  {
>  	acpi_no_initrd_override = 1;
>  	return 1;

