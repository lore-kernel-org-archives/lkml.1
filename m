Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbXINQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbXINQOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXINQNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:13:51 -0400
Received: from 8bytes.org ([88.198.83.132]:53229 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbXINQNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:13:51 -0400
Date: Fri, 14 Sep 2007 18:13:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Message-ID: <20070914161345.GB8998@8bytes.org>
References: <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <46E9DDC7.4000403@hauppauge.com> <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com> <46EA3F07.9050806@gmail.com> <20070914091535.GA8998@8bytes.org> <46EA77DE.8060109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EA77DE.8060109@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 04:00:30PM +0400, Manu Abraham wrote:
> Joerg Roedel wrote:
> > On Fri, Sep 14, 2007 at 11:57:59AM +0400, Manu Abraham wrote:
> >>>>> What do you think about IOMMU?
> >>>>>
> >>>>>
> >>>> Just because AMD or INTEL want to invent some whizzy new technology it
> >>>> doesn't say anything about the TV card development and retail business.
> >>>> Intel and AMD have teams of Linux engineers helping operating system
> >>>> developers bring their ideas and technologies to new platforms. That's a
> >>>> million miles away from any of the TV board vendors I know of, who have
> >>>> little or NO fulltime linux developers and consider the < 5% market
> >>>> fringe at best.
> >>>>
> >>> it helps to virtualize devices and introduces newer features for that.
> >>> Some interesting projects could be derrived out of that, there are
> >>> quite a few interesting papers floating around how drivers could be
> >>> handled in future.
> >>>
> >> IOMMU can be considered similar to the AGP GART, which is similar,
> >> remapping the Addresses, as far as i understand.
> > 
> > Common new IOMMUs have only very few in common with the AGP GART. In
> > fact, with current modern IOMMU hardware it will be possible to
> > implement secure userspace device drivers that are even able to do DMA.
> > This is not possible with the GART.
> > 
> >> Though you get a physical to virtual translation, what about interrupts,
> > 
> > Modern IOMMUs are able to remap interrupts. This will solve the problem
> > with PCI interrupt sharing.
> 
> What CPU's are we talking about ?

IOMMUs are not necessarily a CPU feature. These IOMMUS will be found in
the South/North Bridge or even on PCI devices itself (uncommon). The
Calgary IOMMU is such an example of an IOMMU not implemented on the CPU
itself.

Joerg
