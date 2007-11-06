Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXKFGq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXKFGq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXKFGqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:46:49 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:24211 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbXKFGqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ClOYw3aE/PA6iisembl3AEw3oGV02mMKONjTrSaKHQA1piWWGHJUvNsIZh4CPKRfPG5UDeEQPHyLblVNBUTB1z7Eg77bNwgZEo67c/+YBEKtRKTi40bbHmk6nBgi2jbPu2PtRkj+VIh9X1LBOBUWUIQAFJn1HRKmnRxDQll3vyc=
Message-ID: <386072610711052246n3c0adff0jc5739db5ab29f238@mail.gmail.com>
Date: Tue, 6 Nov 2007 14:46:47 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 3/4] Blackfin SPI driver: move hard coded pin_req to board file
Cc: "Bryan Wu" <bryan.wu@analog.com>, akpm@linux-foundation.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200711052203.42855.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193971112-7744-1-git-send-email-bryan.wu@analog.com>
	 <1193971112-7744-4-git-send-email-bryan.wu@analog.com>
	 <200711052203.42855.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, David Brownell <david-b@pacbell.net> wrote:
> On Thursday 01 November 2007, Bryan Wu wrote:
> > --- a/include/asm-blackfin/bfin5xx_spi.h
> > +++ b/include/asm-blackfin/bfin5xx_spi.h
> > @@ -152,6 +152,7 @@
> > struct bfin5xx_spi_master {
> > u16 num_chipselect;
> > u8 enable_dma;
> > +u16 pin_req[4];
> > };
> >
> > /* spi_board_info.controller_data for SPI slave devices,
>
> I take it there's a patch some where -- outside of this set
> of four -- to initialize that new field so drivers will get
> valid pin setup data?  (That name doesn't sound like it's
> platform data, by the way.)
>
> That's going to need to merge in sync with this patch, else
> I'd think the resulting kernel won't run ...
>

Yes, I have another patch to add this pin_req field in arch/blackfin
board files.
It is in my blackfin patch queue and will be submitted to upstream later.

Thanks a lot
-Bryan
