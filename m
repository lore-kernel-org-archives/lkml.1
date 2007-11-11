Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbXKKUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbXKKUP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbXKKUPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:15:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36884 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbXKKUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:15:14 -0500
Date: Sun, 11 Nov 2007 20:15:03 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       paulus@samba.org
Subject: Re: [PATCH] powerpc: Add EXPORT_SYMBOL for symbols required by fs_enet and cpm_uart
Message-ID: <20071111201503.GA18749@infradead.org>
References: <47373571.3070605@scram.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47373571.3070605@scram.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 06:01:37PM +0100, Jochen Friedrich wrote:
> --- a/arch/powerpc/sysdev/commproc.c
> +++ b/arch/powerpc/sysdev/commproc.c
> @@ -51,6 +51,8 @@ static void m8xx_cpm_dpinit(void);
> static uint host_buffer; /* One page of host buffer */
> static uint host_end;    /* end + 1 */
> cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
> +EXPORT_SYMBOL(cpmp);

Sorry, but this is a nightmare waiting to happen.  Please define
proper accessors instead.  (And get rid of the typedef while you're
at it)


