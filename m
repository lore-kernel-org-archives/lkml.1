Return-Path: <linux-kernel-owner+w=401wt.eu-S1763123AbXF0U3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763123AbXF0U3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXF0U3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:29:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:58112 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbXF0U3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=srXb9OX4nP0FvEnHit+IGYrK/NNT4Mves3glmKkrJViUBzrKNVVPTCx2+4qV0yAvIP2NKR6TVkN/wXkY385RmWOo28muCwLamis2qUe9z8nJaRN2HwAF/727/BISAkNO5Hrx9KsGDVlvhWM68Y31Wp2ngxYOaV/bZ/bGjB18av8=
Message-ID: <86802c440706271329m62f4d132nddd250bd3931db97@mail.gmail.com>
Date: Wed, 27 Jun 2007 13:29:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706272226.29231.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706271041.21937.yinghai.lu@sun.com>
	 <200706272222.25153.ak@suse.de>
	 <86802c440706271325w3a8b6d9aybb8a346b9b2eb345@mail.gmail.com>
	 <200706272226.29231.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 27 June 2007 22:25:11 Yinghai Lu wrote:
> > On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> > > On Wednesday 27 June 2007 19:41:21 Yinghai Lu wrote:
> > > > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> > > >
> > > > there function is called via dma_ops->.., so change it to static
> > >
> > > Actually all these functions shouldn't be inline in the first place.
> >
> > do you mean pci_map_single==>dma_map_single==>gart_map_single?
>
> dma_map_single. pci_map_single is ok because it doesn't really
> change anything.

move dma_map_single from include/asm-x86_64/dma_mapping.h to
arch/x86_64/pci-dma.c?

YH
