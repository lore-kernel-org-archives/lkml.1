Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYISSBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYISSBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYISSBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:01:33 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21921 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYISSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:01:32 -0400
X-BigFish: VPS-34(z1039oz146fK1418M1432R98dR1805M179dR936fQ873fnzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7GFE2-03-WUO-01
Date: Fri, 19 Sep 2008 20:01:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919180118.GV24392@amd.com>
References: <20080919164541.GS24392@amd.com> <20080920020917O.fujita.tomonori@lab.ntt.co.jp> <20080919173004.GA9837@amd.com> <20080920024046W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920024046W.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 18:01:19.0094 (UTC) FILETIME=[B7A55960:01C91A81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 02:40:35AM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 19:30:04 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > > 
> > > Please keep it for AMD option for now. Please send a patch to make it
> > > generic to other IOMMU people and give them a chance to discuss on
> > > it.
> > >
> > 
> > Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
> > flushing"
> > 
> > 
> >  > True. We should merge common parameters across IOMMUs into the
> >  > iommu= parameter some time in the future, I think. It would also be the
> >  > place for the IOMMU size parameter.
> > 
> >  Hmm, now is better than the future? I think that now you can add
> >  something like 'disable_batching_flush' as a common parameter and
> >  change AMD IOMMU to use it.
> > 
> > in http://lkml.org/lkml/2008/9/17/376
> > 
> > And since we already have a iommu=fullflush parameter it makes sense of
> > make it generic.
> 
> I'm not against fullflush but we need to discuss it with other people
> before making the change.

Weird. Just 2 hours ago you wrote:

|http://lkml.org/lkml/2008/9/19/106
|
|For me, adding these boot parameters doesn't make sense.

Anyway, I wrote to the Intel and Calgary developers and asked them for
their opinion. If they have real objections I am the last person NACKing
your original patch in this thread again.
The reason why I queued this patch in AMD IOMMU updates was that I
didn't wanted to implement an option specificly for AMD IOMMU when there
will be a generic one soon. This is double work I prefered to do it
right in the first step. The change does not break anything on Intel and
Calgary.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

