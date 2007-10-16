Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXJPIIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXJPIIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXJPII0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:08:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:47309 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXJPIIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZSKKckYV2vbLp4yVeMnEfTgPbQ531NeL/eueDKgsjLiXI1vdCMj7qGi8/l/YquW+dWpEXf6yOnX8h9O3V25UB4lVDliMZfdo+cuNqPre+EN/yuKVHT52F8euoJlOOgSwug1K8XTf2d2EBTxuDI1aoHjEVmt7YnXTNkeptbEyfXY=
Message-ID: <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
Date: Tue, 16 Oct 2007 16:08:22 +0800
From: "peer chen" <peerchen@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       "Kuan Luo" <kluo@nvidia.com>
In-Reply-To: <470FE47B.5060505@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I hope one of the following patches can be merged to 2.6.24.
==========================
http://lkml.org/lkml/2007/10/8/93
http://lkml.org/lkml/2007/9/25/20

Yes, I agree to set the 'swncq' as default for 2.6.24, after all, for
our server customers, stability is far more important than the new
feature no matter the problem is caused by drive or controller.


2007/10/13, Jeff Garzik <jeff@garzik.org>:
> Peer Chen wrote:
> > Add the ahci controller legacy mode support to sata_nv.
> > Move the DIDs of legacy mode from ahci.c to sata_nv.c
> >
> > The patch base on kernel 2.6.23-rc8
> >
> > Signed-off-by: Peer Chen <peerchen@gmail.com>
>
> Would you mind checking libata-dev.git#upstream, and make sure it has
> all the NV patches?
>
> I'm thinking I should go ahead and push the 'nv-swncq' branch, which
> contains the sata_nv updates for swncq.  They have been in -mm for a
> while.  I am leaning towards leaving the default to 'off' for 2.6.24 though.
>
> Comments welcome...
>
>        Jeff
>
>
>
>
