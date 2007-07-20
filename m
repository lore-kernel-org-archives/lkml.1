Return-Path: <linux-kernel-owner+w=401wt.eu-S935244AbXGTRbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244AbXGTRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763016AbXGTRbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:31:39 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:36254 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762994AbXGTRbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:31:38 -0400
Date: Fri, 20 Jul 2007 18:31:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [patch 3/3] scsi: wd33c93 needs <asm/irq.h>
Message-ID: <20070720173132.GB19424@linux-mips.org>
References: <20070720164043.523003359@mail.of.borg> <20070720164324.097994947@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720164324.097994947@mail.of.borg>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:40:46PM +0200, Geert Uytterhoeven wrote:

> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -89,6 +89,8 @@
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  
> +#include <asm/irq.h>

These days that should probably be <linux/irq.h>.

  Ralf
