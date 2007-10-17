Return-Path: <linux-kernel-owner+w=401wt.eu-S935867AbXJQA0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867AbXJQA0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXJQAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:25:54 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39828 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760278AbXJQAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:25:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=P2albyflhmI5fr6tPgq1aEnFiPVcvhx9g/RNT1Ci5IlbsJtqi/jhsz/NTcSsA6GskostrAj2C2RLGVGfhTqpHw8xWsEosR1KIC2bF5Cg4bao51HlgOZ4FO8X/MQcgwdojZjjWQfW1CWAWzzR09pqxxtKlxji1NLiV8NvEIsu540=  ;
X-YMail-OSG: aZ9fy6YVM1lszieyt0HUZFQf8K3DW9JBK88j.mi5wBkxppTBVR7ooNVFU_mvSmJPXK9i7CEW9Q--
Date: Tue, 16 Oct 2007 17:25:51 -0700
From: David Brownell <david-b@pacbell.net>
To: viro@ftp.linux.org.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH] missing include in mmc
Cc: linux-kernel@vger.kernel.org
References: <20071017000907.GF8181@ftp.linux.org.uk>
In-Reply-To: <20071017000907.GF8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071017002551.3577B23B309@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From viro@ftp.linux.org.uk  Tue Oct 16 17:18:43 2007
> Date: Wed, 17 Oct 2007 01:09:07 +0100
> From: Al Viro <viro@ftp.linux.org.uk>
> To: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
> Subject: [PATCH] missing include in mmc
>
> AFAICS, fallout from repacing include of blkdev.h with include of bio.h.

Out of curiousity, which architecture(s) need this?

I did test builds on three, and didn't see a need for it ...



> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index 71b986b..7ae18ea 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -30,6 +30,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/crc7.h>
>  #include <linux/crc-itu-t.h>
> +#include <linux/scatterlist.h>
>  
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/mmc.h>		/* for R1_SPI_* bit values */
>
