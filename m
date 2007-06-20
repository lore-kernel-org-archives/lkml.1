Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbXFTDib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbXFTDib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761134AbXFTDiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:38:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:34692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760304AbXFTDiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:38:13 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Date: Tue, 19 Jun 2007 23:38:02 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070619225035.GI5193@alberich.amd.com>
In-Reply-To: <20070619225035.GI5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706192338.02807.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 18:50, Andreas Herrmann wrote:
> Avoid compile warning if !ACPI_BLACKLIST_YEAR
> 
>   CC      drivers/acpi/blacklist.o
>   drivers/acpi/blacklist.c:76:5: warning: "CONFIG_ACPI_BLACKLIST_YEAR" is not defined

How were you able to produce a .config with CONFIG_ACPI_BLACKLIST_YEAR not defined?
Can you send it to me?

thanks,
-Len

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/acpi/blacklist.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
> index 3ec110c..ac96c47 100644
> --- a/drivers/acpi/blacklist.c
> +++ b/drivers/acpi/blacklist.c
> @@ -73,7 +73,7 @@ static struct acpi_blacklist_item acpi_blacklist[] __initdata = {
>  	{""}
>  };
>  
> -#if	CONFIG_ACPI_BLACKLIST_YEAR
> +#if	defined(CONFIG_ACPI_BLACKLIST_YEAR) && CONFIG_ACPI_BLACKLIST_YEAR
>  
>  static int __init blacklist_by_year(void)
>  {
