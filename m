Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXINS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXINS7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbXINS70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:59:26 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:45866 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXINS7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SEi2dfVQ/iuTxJKDJwCRvgh34FUhw2IHqk4ivmJwCLP5I7ehz+oI9BL/QtsO4cM6m5R20usN6njXWdk/ZzDNo/h/Sn/srAxdqHQttXLE1WiDC3DTnAEdw56knB0vOoCaeXubtMHmr/cRLSkHaU0nIHMhtPaJoUaOuOXQ7f6JGO8=
Message-ID: <d9def9db0709141159r1b520168hf2fcec1cd1007140@mail.gmail.com>
Date: Fri, 14 Sep 2007 20:59:23 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alex Deucher" <alexdeucher@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Manu Abraham" <abraham.manu@gmail.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <a728f9f90709141152n5a2c9a65wa1bd53085741da1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <46EA3F07.9050806@gmail.com> <20070914091535.GA8998@8bytes.org>
	 <46EA77DE.8060109@gmail.com>
	 <d9def9db0709140909s5caceb6braf2b10213e721702@mail.gmail.com>
	 <a728f9f90709141152n5a2c9a65wa1bd53085741da1e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Alex Deucher <alexdeucher@gmail.com> wrote:
> On 9/14/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > On 9/14/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > > Joerg Roedel wrote:
> > > > On Fri, Sep 14, 2007 at 11:57:59AM +0400, Manu Abraham wrote:
> > > >>>>> What do you think about IOMMU?
> > > >>>>>
> > > >>>>>
> > > >>>> Just because AMD or INTEL want to invent some whizzy new technology
> it
> > > >>>> doesn't say anything about the TV card development and retail
> business.
> > > >>>> Intel and AMD have teams of Linux engineers helping operating
> system
> > > >>>> developers bring their ideas and technologies to new platforms.
> That's
> > > a
> > > >>>> million miles away from any of the TV board vendors I know of, who
> have
> > > >>>> little or NO fulltime linux developers and consider the < 5% market
> > > >>>> fringe at best.
> > > >>>>
> > > >>> it helps to virtualize devices and introduces newer features for
> that.
> > > >>> Some interesting projects could be derrived out of that, there are
> > > >>> quite a few interesting papers floating around how drivers could be
> > > >>> handled in future.
> > > >>>
> > > >> IOMMU can be considered similar to the AGP GART, which is similar,
> > > >> remapping the Addresses, as far as i understand.
> > > >
> > > > Common new IOMMUs have only very few in common with the AGP GART. In
> > > > fact, with current modern IOMMU hardware it will be possible to
> > > > implement secure userspace device drivers that are even able to do
> DMA.
> > > > This is not possible with the GART.
> > > >
> > > >> Though you get a physical to virtual translation, what about
> interrupts,
> > > >
> > > > Modern IOMMUs are able to remap interrupts. This will solve the
> problem
> > > > with PCI interrupt sharing.
> > >
> > > What CPU's are we talking about ?
> > >
> >
> > upcoming x86-64 processors from the AMD side. I'm not into what Intel
> > is doing in that area at the moment.
>
> All AMD64 chips have an IOMMU.  Only Intel's most recent chips do.
>

It's not available yet, you can read more about it in the following article:

http://developer.amd.com/articlex.jsp?id=101

If you're interested in it I can put together some more information about
it.

Markus
