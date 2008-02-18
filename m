Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYBROSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYBROSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYBRORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:17:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbYBRORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:17:53 -0500
From: Andreas Schwab <schwab@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, apw@shadowen.org
Subject: Re: [PATCH] next-20080218 build failure at pmac_ide_macio_attach ()
References: <20080218140159.GA31310@linux.vnet.ibm.com>
X-Yow: How's the wife?  Is she at home enjoying capitalism?
Date: Mon, 18 Feb 2008 15:17:49 +0100
In-Reply-To: <20080218140159.GA31310@linux.vnet.ibm.com> (Kamalesh Babulal's
	message of "Mon\, 18 Feb 2008 19\:31\:59 +0530")
Message-ID: <jeodae4acy.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> writes:

> --- linux-2.6.25-rc1/drivers/ide/ppc/pmac.c	2008-02-18 18:41:48.000000000 +0530
> +++ linux-2.6.25-rc1/drivers/ide/ppc/~pmac.c	2008-02-18 19:20:37.000000000 +0530
> @@ -1091,7 +1091,7 @@ pmac_ide_macio_attach(struct macio_dev *
>  	int irq, rc;
>  	hw_regs_t hw;
>  
> -	pmif = (struct pmac_ide_hwif)kzalloc(sizeof(*pmif), GFP_KERNEL);
> +	pmif = (struct pmac_ide_hwif*)kzalloc(sizeof(*pmif), GFP_KERNEL);

Just remove the cast.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
