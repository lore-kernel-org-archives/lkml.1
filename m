Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbXINQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbXINQJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759204AbXINQJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:09:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:54948 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933788AbXINQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hEfTRqUJSt2rbTqFDqewH+XsQDNKNuF4Qb6OJCByOd+Y0b0+GNLOtUWU4xQvoQ1ddI/3z56ya9y8z8ZjTFRvCTMHImsJHKIRDK+OkP+HGINNQHl44jxVMUDXhRriEKMB+SYO7vyUia69+sh7lnw2o5IHYipkr1gIruOClYE5seo=
Message-ID: <d9def9db0709140909s5caceb6braf2b10213e721702@mail.gmail.com>
Date: Fri, 14 Sep 2007 18:09:28 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Joerg Roedel" <joro@8bytes.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <46EA77DE.8060109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <46EA3F07.9050806@gmail.com> <20070914091535.GA8998@8bytes.org>
	 <46EA77DE.8060109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> Joerg Roedel wrote:
> > On Fri, Sep 14, 2007 at 11:57:59AM +0400, Manu Abraham wrote:
> >>>>> What do you think about IOMMU?
> >>>>>
> >>>>>
> >>>> Just because AMD or INTEL want to invent some whizzy new technology it
> >>>> doesn't say anything about the TV card development and retail business.
> >>>> Intel and AMD have teams of Linux engineers helping operating system
> >>>> developers bring their ideas and technologies to new platforms. That's
> a
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
>

upcoming x86-64 processors from the AMD side. I'm not into what Intel
is doing in that area at the moment.

Markus
