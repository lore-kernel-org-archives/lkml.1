Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbXKWKTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbXKWKTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXKWKTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:19:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47478 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbXKWKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:19:41 -0500
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash
	controller driver support in bf5xx_nand driver
From: David Woodhouse <dwmw2@infradead.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <1195812893-26312-1-git-send-email-bryan.wu@analog.com>
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 10:19:38 +0000
Message-Id: <1195813178.25590.35.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-23 at 18:14 +0800, Bryan Wu wrote:
> 
> +#ifdef CONFIG_BF54x
>         /* Setup DMAC1 channel mux for NFC which shared with SDH */
>         val = bfin_read_DMAC1_PERIMUX();
>         val &= 0xFFFE;
>         bfin_write_DMAC1_PERIMUX(val);
>         SSYNC();
> -
> +#endif

You can't build a multiplatform kernel which runs on BF52x and BF54x?
And want to make it harder to do so in future?

-- 
dwmw2

