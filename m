Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbXIYRZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbXIYRZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXIYRZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:25:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:41813 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXIYRZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aSh85ssrUC4YvaquO8lLkxq6lifN6mgiLuPQwh0tkrLXadauFvsVpiA56TYnvcAPj8iVmegciqQB3vMeGCqlyTU6dmLVY5O67KT+l0jLwCgL6/JLtmc1u1Wzn/Tfglx+OZZMW5pADXC/++MXxFirkgtEJsz7yfcSrZeDapaJSJ8=
Message-ID: <6101e8c40709251025r1137f246xad8e99f273f65677@mail.gmail.com>
Date: Tue, 25 Sep 2007 19:25:33 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Linux 2.6.22.8, pata_ali issue
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <Pine.LNX.4.64.0709251923410.945@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070925062115.GA18444@kroah.com>
	 <6101e8c40709250909x53b44274i17694e64dccae427@mail.gmail.com>
	 <20070925161430.GA14212@suse.de>
	 <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
	 <6101e8c40709251021s602f8f55id40c327ac871345f@mail.gmail.com>
	 <Pine.LNX.4.64.0709251923410.945@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

my git top is:

commit 0dc661f882011b941b8b4d4dac84d7a0371f7a7b
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Mon Sep 24 23:05:13 2007 -0700

    Linux 2.6.22.8


On 9/25/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Sep 25 2007 19:21, Oliver Pinter wrote:
> >
> >the rev is locali declared:
> >
> >[snap]
> >
> > ...
> >
> >static void ali_init_chipset(struct pci_dev *pdev)
> >{
> >        u8 rev, tmp;
> >        struct pci_dev *north, *isa_bridge;
> >
> >        pci_read_config_byte(pdev, PCI_REVISION_ID, &rev);
> >
> > ...
> >
> >[snap]
> >
> >what's the git id in git tree?
>
> Huh? My top git is 4942de4a0e914f205d351a81873f4f63986bcc3c
> and it has this:
>
> static void ali_init_chipset(struct pci_dev *pdev)
>
> {
>
>         u8 tmp;
>
>         struct pci_dev *north, *isa_bridge;
>
>
>         /*
>
>          * The chipset revision selects the driver operations and
>
>          * mode data.
>
>          */
>
>
>         if (pdev->revision >= 0x20 && pdev->revision < 0xC2) {
>
>
>
> No pci_read_config_byte here..
>
>


-- 
Thanks,
Oliver
