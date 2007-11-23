Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXKWOZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXKWOZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 09:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXKWOZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 09:25:31 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:50023 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXKWOZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 09:25:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U1IxrmDlnMmyvFYUxvWtz+90L9K4v1YTEB10cihKM40GzHIP9J2lln0ipHUZxvMK/emfO+QF9XZIOK8OZysOVzBN8sRgdmI1SiQ0Tiulmouzls4JPhqGXj6AjcrViYf0NNmU8gyPRxkwaIIIPcY95D4BuzxL3an2dj4LhZCOzHw=
Message-ID: <386072610711230625k23b68e49q6090b7eb27c2c039@mail.gmail.com>
Date: Fri, 23 Nov 2007 22:25:29 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash controller driver support in bf5xx_nand driver
Cc: "Bryan Wu" <bryan.wu@analog.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <1195813178.25590.35.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com>
	 <1195813178.25590.35.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23, 2007 6:19 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Fri, 2007-11-23 at 18:14 +0800, Bryan Wu wrote:
> >
> > +#ifdef CONFIG_BF54x
> >         /* Setup DMAC1 channel mux for NFC which shared with SDH */
> >         val = bfin_read_DMAC1_PERIMUX();
> >         val &= 0xFFFE;
> >         bfin_write_DMAC1_PERIMUX(val);
> >         SSYNC();
> > -
> > +#endif
>
> You can't build a multiplatform kernel which runs on BF52x and BF54x?

There are some hardware difference between BF52x and BF54x. We have to do this.

> And want to make it harder to do so in future?
>
Any idea to make it easier? providing a specific hardware init hook
function from each platform board files?

Regards,
-Bryan

> --
> dwmw2
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
