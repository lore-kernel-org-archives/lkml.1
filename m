Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbXJVB4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbXJVB4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 21:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJVB4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 21:56:01 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:25641 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbXJVB4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 21:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bdYLlLxLi8Q9F59tvQoMlk4D8+8Q+XnKwGmKr3x7WQCuTWmQFGu1joDP2SaBan5hrFmp2MB7JO3QrjsXIK5Vxp4bE1rkSZ+WNrnoOEM5jERc3lJ6yJSemIAXkWqyGDlSP7fQuU//9B2tWLaPP1uB8SLOuXmYF0znLyzZa7DdXpA=
Message-ID: <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com>
Date: Mon, 22 Oct 2007 09:55:58 +0800
From: "peer chen" <peerchen@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       "Kuan Luo" <kluo@nvidia.com>
In-Reply-To: <47185BFD.2010909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org>
	 <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com>
	 <47181CE1.4000802@garzik.org>
	 <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com>
	 <47185BFD.2010909@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, link - http://lkml.org/lkml/2007/10/8/93 add the AHCI legacy
support to sata_nv when IDE/RAID mode been set in SBIOS and Device IDs
are not in ahci.c at this moment. To do so, when a new chipset come
out and DIDs haven't been submited to LKML,user still can use ahci
driver to handle it when setting AHCI mode in BIOS, using sata_nv when
setting RAID/IDE in BIOS.
For example, ahci driver in Fedora 7 doesn't include the DIDs of
MCP78, so if you set the IDE/RAID mode in BIOS, os installation onto
SATA drive will fail. But if Fedora 7 include this patch, installation
will be successful.

2007/10/19, Jeff Garzik <jeff@garzik.org>:
> peer chen wrote:
> > Ok,I agree to use AHCI driver for our AHCI controllers no matter their
> > class codes are IDE/RAID/AHCI. But for those new or upcoming AHCI
> > controller which DIDs are not included in ahci.c and also IDE/RAID
> > mode being set in BIOS, no driver will be loaded currently, so I hope
> > the first patch http://lkml.org/lkml/2007/10/8/93 can be appied for
> > this case. Any comments?
>
> hmmm is that the correct URL?  That one updates sata_nv to support AHCI
> controllers?.
>
> I would think you would want to add the RAID class code to ahci.c
> instead?  And just some regular PCI IDs?
>
>        Jeff
>
>
>
