Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXIMQ0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXIMQ0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXIMQ0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:26:00 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:50223 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbXIMQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:25:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HB+vOuy/bwd3Oafd6Vr+pPAjI3QIvkleUyySreYpEv6Kd+n96fssPlE2V/RfFPnHnQDIWMsCXWna/W5nfrdWp0qiPuA40XG4au1yBLL2b/6z22USTpjvsAz7akCk7fiUQFSsodC5vbkcCKfasGdoRrkco5H6QceaIO18JH06tW4=
Message-ID: <e9c3a7c20709130925s2234d652ne43bf44e204ac4e8@mail.gmail.com>
Date: Thu, 13 Sep 2007 09:25:57 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xxprocessors.
Cc: "Wood Scott-B07421" <scottwood@freescale.com>, paulus@samba.org,
       shannon.nelson@intel.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46B96294322F7D458F9648B60E15112C85D8A5@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
	 <20070907223553.GA18599@freescale.com>
	 <46B96294322F7D458F9648B60E15112C85D8A5@zch01exm26.fsl.freescale.net>
X-Google-Sender-Auth: 303d0a360e1eb95a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Zhang Wei-r63237 <Wei.Zhang@freescale.com> wrote:
> Hi,
>
> > > +static void fsl_dma_set_src(dma_addr_t addr,
> > > +                           struct dma_async_tx_descriptor
> > *tx, int index)
> > > +{
> >
> > What is index supposed to mean?  It's not used, or documented
> > anywhere than
> > I can see.
>
> I've also got more document here. Hi, Dan, could you give me some
> explanation about this API? :)
>
The index field gets used for multi-source (or multi-dest) operations.
 XOR, for example, is a multi-source operation.  I am preparing a
documentation patch.

[..]

--
Dan
