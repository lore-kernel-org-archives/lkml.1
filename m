Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948Ab0AVRcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0AVRcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432Ab0AVRcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:32:13 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60435 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0AVRcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:32:13 -0500
MIME-Version: 1.0
In-Reply-To: <20100122124515.2619.14103.stgit@station520.octasic.com>
References: <20100122124515.2619.14103.stgit@station520.octasic.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Jan 2010 10:31:51 -0700
X-Google-Sender-Auth: c2ae705d52d00150
Message-ID: <fa686aa41001220931r4ab1a2afy4ce8796e4a85d887@mail.gmail.com>
Subject: Re: [PATCH] dw_spi_mmio depends on HAVE_CLK
To: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 5:45 AM, Jean-Hugues Deschenes
<jean-hugues.deschenes@octasic.com> wrote:
> dw_spi_mmio is dependent on the clock framework. This marks it as such
> in Kconfig.
>
>
> Signed-off-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>

applied, thanks.

g.

> ---
>  drivers/spi/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 505f1c2..c1ac092 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -319,7 +319,7 @@ config SPI_DW_PCI
>
>  config SPI_DW_MMIO
>        tristate "Memory-mapped io interface driver for DW SPI core"
> -       depends on SPI_DESIGNWARE
> +       depends on SPI_DESIGNWARE && HAVE_CLK
>
>  #
>  # There are lots of SPI device types, with sensors and memory
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
