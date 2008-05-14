Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYENAMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYENAMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYENAMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:12:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:41135 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbYENAME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:12:04 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: [PATCH] ACPI 2.6.26-rc2: Add missing newline to DSDT/SSDT warning message
Date: Tue, 13 May 2008 20:11:43 -0400
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200805121913.09502.alistair@devzero.co.uk>
In-Reply-To: <200805121913.09502.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805132011.43442.lenb@kernel.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [140.211.167.34]); Wed, 14 May 2008 00:11:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-len

On Monday 12 May 2008, Alistair John Strachan wrote:
> As of recently (probably 2.6.26-rc1) I've been getting the following mangling
> in the kernel log:
> 
> [4294014.568167] ACPI: DSDT override uses original SSDTs unless "acpi_no_auto_ssdt"<6>CPU0: Intel(R) Pentium(R) Dual  CPU  E2160  @ 1.80GHz stepping 0d
> 
> This is due to a missing newline character in the first message. The following
> patch against 2.6.26-rc2 fixes it. Please apply.
> 
> Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
> ---
> 
> diff --git a/drivers/acpi/tables/tbxface.c b/drivers/acpi/tables/tbxface.c
> index fb57b93..0e31960 100644
> --- a/drivers/acpi/tables/tbxface.c
> +++ b/drivers/acpi/tables/tbxface.c
> @@ -540,7 +540,7 @@ static acpi_status acpi_tb_load_namespace(void)
>  		acpi_tb_print_table_header(0, table);
>  
>  		if (no_auto_ssdt == 0) {
> -			printk(KERN_WARNING "ACPI: DSDT override uses original SSDTs unless \"acpi_no_auto_ssdt\"");
> +			printk(KERN_WARNING "ACPI: DSDT override uses original SSDTs unless \"acpi_no_auto_ssdt\"\n");
>  		}
>  	}
>  


