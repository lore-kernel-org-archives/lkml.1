Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXICQqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXICQqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXICQqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:46:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57422 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbXICQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:46:36 -0400
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
From: David Woodhouse <dwmw2@infradead.org>
To: bryan.wu@analog.com
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1188804323.29566.6.camel@roc-laptop>
References: <1188804323.29566.6.camel@roc-laptop>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 17:46:30 +0100
Message-Id: <1188837990.6075.32.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 15:25 +0800, Bryan Wu wrote:
> +       if (hardware_ecc) {
> +               if (plat->page_size == NFC_PG_SIZE_256) {
> +                       chip->ecc.bytes = 3;
> +                       chip->ecc.size = 256;
> +               } else if (mtd->writesize == NFC_PG_SIZE_512) { 

Comparing against plat->page_size in one case, but mtd->writesize in the
other? And elsewhere it seems plat->page_size is treated as a boolean,
indicating only 256-byte vs. 512-byte pages (you don't support 2KiB or
other page sizes at all?)

-- 
dwmw2

