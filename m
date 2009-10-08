Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZJHPjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZJHPjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZJHPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:39:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33831 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597AbZJHPjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:39:11 -0400
From: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>,
       "Pedanekar, Hemant" <hemantp@ti.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
       "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Oct 2009 10:37:28 -0500
Subject: RE: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
Thread-Topic: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
Thread-Index: AcpIKlI7GRpODXW0RMylKxy3TdpkMgAAp08A
Message-ID: <7A436F7769CA33409C6B44B358BFFF0C012A6FC76F@dlee02.ent.ti.com>
References: <1254407106-19390-1-git-send-email-hemantp@ti.com>
 <87tyy9dih1.fsf@deeprootsystems.com>
In-Reply-To: <87tyy9dih1.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Could you please apply this patch to the -mm tree and thus queue it up for 2.6.32-rc series?

Thanks
Sneha

> -----Original Message-----
> From: davinci-linux-open-source-bounces@linux.davincidsp.com
> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
> Of Kevin Hilman
> Sent: Thursday, October 08, 2009 11:16 AM
> To: Pedanekar, Hemant
> Cc: Artem.Bityutskiy@nokia.com; davinci-linux-open-
> source@linux.davincidsp.com; dbrownell@users.sourceforge.net; linux-
> mtd@lists.infradead.org; akpm@linux-foundation.org; dwmw2@infradead.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] mtd: nand: davinci: fix to use mask_ale from pdata
> 
> Hemant Pedanekar <hemantp@ti.com> writes:
> 
> > Correct typo to use mask_ale from platform data when set to non-zero.
> >
> > Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
> 
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> 
> Could this fix be queued for the .32-rc series please?
> 
> Thanks,
> 
> Kevin
> 
> > ---
> >  drivers/mtd/nand/davinci_nand.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/mtd/nand/davinci_nand.c
> b/drivers/mtd/nand/davinci_nand.c
> > index 0fad648..20b04a2 100644
> > --- a/drivers/mtd/nand/davinci_nand.c
> > +++ b/drivers/mtd/nand/davinci_nand.c
> > @@ -571,7 +571,7 @@ static int __init nand_davinci_probe(struct
> platform_device *pdev)
> >  	info->mask_chipsel	= pdata->mask_chipsel;
> >
> >  	/* use nandboot-capable ALE/CLE masks by default */
> > -	info->mask_ale		= pdata->mask_cle ? : MASK_ALE;
> > +	info->mask_ale		= pdata->mask_ale ? : MASK_ALE;
> >  	info->mask_cle		= pdata->mask_cle ? : MASK_CLE;
> >
> >  	/* Set address of hardware control function */
> > --
> > 1.6.2.4
> >
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
