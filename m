Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbXFTA57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbXFTA57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 20:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbXFTA5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 20:57:50 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41032 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754831AbXFTA5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 20:57:49 -0400
X-Sasl-enc: dGISx9RbnvgsPj/XrQgo33O99P2OyGemTerJ+V7Fw9DL 1182301075
Date: Tue, 19 Jun 2007 21:57:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/12] acpi: select ACPI_EC for THINKPAD_ACPI
Message-ID: <20070620005744.GA15080@khazad-dum.debian.net>
References: <20070619224836.GD5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619224836.GD5193@alberich.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Andreas Herrmann wrote:
> Fix kernel build problem:
> 
>  thinkpad_acpi.c:(.text+0x7486a): undefined reference to `ec_write'
> 
> (as THINKPAD_ACPI depends on ACPI_EC)
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 2f2fbff..72774c9 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -139,6 +139,7 @@ config SONYPI_COMPAT
>  config THINKPAD_ACPI
>  	tristate "ThinkPad ACPI Laptop Extras"
>  	depends on X86 && ACPI
> +	select ACPI_EC
>  	select BACKLIGHT_CLASS_DEVICE
>  	select HWMON
>  	---help---

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
