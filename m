Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbXHHTYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbXHHTYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 15:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbXHHTY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 15:24:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbXHHTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 15:24:24 -0400
Date: Wed, 8 Aug 2007 12:24:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] libata: check for AN support
Message-Id: <20070808122402.5bd6dc4a.akpm@linux-foundation.org>
In-Reply-To: <20070808120810.5f8ed457.kristen.c.accardi@intel.com>
References: <20070808190613.616085010@localhost.localdomain>
	<20070808120810.5f8ed457.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 12:08:10 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> ===================================================================
> --- 2.6-git.orig/include/linux/libata.h
> +++ 2.6-git/include/linux/libata.h
> @@ -139,7 +139,8 @@ enum {
>  	ATA_DFLAG_FLUSH_EXT	= (1 << 4), /* do FLUSH_EXT instead of FLUSH */
>  	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
>  	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
> -	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
> +	ATA_DFLAG_AN		= (1 << 7), /* device supports AN */
> +	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
>  
>  	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
>  	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
> @@ -177,6 +178,7 @@ enum {
>  	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
>  	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
>  	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
> +	ATA_FLAG_AN		= (1 << 18), /* controller supports AN */
>  

It would be nice to at least get bits like this upstream.

<goes off and fixes it again>
