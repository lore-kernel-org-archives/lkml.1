Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYISWSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYISWSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYISWSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:18:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:55592 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYISWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:18:33 -0400
Date: Sat, 20 Sep 2008 07:18:11 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919220946.GB11410@amd.com>
References: <20080919201909.GC10692@amd.com>
	<20080920065630N.fujita.tomonori@lab.ntt.co.jp>
	<20080919220946.GB11410@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920071825A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 00:09:46 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 06:56:21AM +0900, FUJITA Tomonori wrote:
> > 
> > Because you did things int the wrong way, I said again and again.
> > 
> > I can't see why you refuse to do the things in the proper way.
> > 
> > 
> > > objections agains the generic iommu=fullflush come up. The patch does
> > > not break anything and just moves the iommu=flush parameter (which is
> > > already available) to pci-dma.c to make it useable by AMD IOMMU too.
> > 
> > Breaking anything does mean that it's fine. My patch doesn't break
> > anything too.
> > 
> > I'm not against fullflush (as I said again and again). I guess that
> > it's the right move though it might be not so useful if VT-d doesn't
> > support it.
> > 
> > I'm against totally pointless nofullflush and the way you changed the
> > generic IOMMU code.
> 
> Then submit a patch that changes it to the version you prefer. I already
> said that I am fine with the removal of nofullflush. But completly

I don't know it's acceptable if removing the exported interface even
if the maintainer of it wants to remove it and it's totally
meaningless.


> reverting is the wrong way. For AMD IOMMU I want to use the
> iommu=fullflush way because I want to reuse a parameter thats already
> there. Thats why I am against your reverting patch.
> So now I stop repeating my points again and again. EOD.

I understood you want to use iommu=fullflush but you can't touch the
generic code without any discussion.

And even if everyone is happy about the change, it's much better to
start from scratch rather than try to fix the things done in the wrong
way.
