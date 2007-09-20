Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXITDnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXITDnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 23:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXITDmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 23:42:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:10367 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbXITDmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 23:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LGP5uR0fEbgkl6EHRYAp3ELPf0VqCcWA1H2Uv1j3Ca4udNnQqSeQarqd5n+0TSLyYmlNH8gyTLUJOMYcaxEAZJFi3P79ja55Gi/gFvNwkOgo7W7GWe84Izi43NbWQUmN2BoKS1EqGqberiaeltfhmQC1rj7HN8AHa5Nyg/7TIy4=
Message-ID: <8bd0f97a0709192042g67f13337nf62978768b64ff80@mail.gmail.com>
Date: Wed, 19 Sep 2007 23:42:53 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "David McCullough" <David_Mccullough@securecomputing.com>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       "Bernd Schmidt" <bernd.schmidt@analog.com>,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
In-Reply-To: <20070920031807.GA31263@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190102965.4406.9.camel@roc-desktop>
	 <200709192131.09469.rgetz@blackfin.uclinux.org>
	 <20070920015525.GA16615@securecomputing.com>
	 <20070920031807.GA31263@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Sep 20, 2007 at 11:55:25AM +1000, David McCullough wrote:
> > Jivin Robin Getz lays it down ...
> > > On Tue 18 Sep 2007 04:09, Bryan Wu pondered:
> > > > This just adds minimum support for the Blackfin relocations,
> > > > since we don't have enough space in each reloc. The idea
> > > > is to store a value with one relocation so that subsequent ones can
> > > > access it.
> > >
> > > Adding the other appropriate maintainers. for h8, m32r, sh and v850.
> >
> > Looks fine to me,  obviously impacts the existing arches very little.
> > Can't see why it shouldn't get included,
>
> I find it a bit disconcerting that blackfin already depends on this
> in-tree without there being any earlier discussion on making these
> changes.

not really ... this patch was posted before but was lost in the
shuffle ... and i'm not quite sure what you mean by "depends on" ...
if you want to use the FLAT file format on a Blackfin processor, then
this patch is needed, but that isnt the only file format that works on
the Blackfin port as we also have FDPIC ELF

i havent used FLAT files on a Blackfin board in quite a long time actually ...
-mike
