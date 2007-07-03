Return-Path: <linux-kernel-owner+w=401wt.eu-S1759753AbXGCPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbXGCPnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbXGCPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:43:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33100 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbXGCPnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:43:11 -0400
Message-ID: <468A6E8C.3080802@garzik.org>
Date: Tue, 03 Jul 2007 11:43:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Allow modular builds of drivers using ata_dumb_qc_prep
References: <20070703161244.008fc5aa@the-village.bc.nu>
In-Reply-To: <20070703161244.008fc5aa@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 20:50:11.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 21:36:20.000000000 +0100
> @@ -6842,6 +6976,7 @@
>  EXPORT_SYMBOL_GPL(ata_data_xfer);
>  EXPORT_SYMBOL_GPL(ata_data_xfer_noirq);
>  EXPORT_SYMBOL_GPL(ata_qc_prep);
> +EXPORT_SYMBOL_GPL(ata_dumb_qc_prep);

Please combine this with the previous patch and resend, otherwise 
git-bisect is not happy.  This should be bundled with the addition of 
this function.


