Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYH3TZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYH3TZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYH3TZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:25:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57594 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbYH3TZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:25:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 21:29:23 +0200
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302129.24584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Linus Torvalds wrote:
> 
> On Sat, 30 Aug 2008, Linus Torvalds wrote:
> > 
> > We simply shouldn't try to compare the BAR start with randomly chosen 
> > things.
> 
> Btw, looking at that bogus BAR#3 some more: I don't actually think it's 
> even an MCFG resource.
> 
> I think it's literally the resource that describes the HT window for the 
> host bridge. So it's literally like the "root" resource - all external 
> MMIO resources that go over HT have to be in that window.
> 
> IOW, I'm starting to think that it's not even broken. It is probably 
> perfectly real. It's not a "PCI bridge" in the sense that it doesn't 
> bridge one PCI bus to another, but it's a host bridge, and it bridges the 
> CPU memory accesses to another bus. 
> 
> The fact that the MCFG area happens to be at the start of that window is 
> probably just a random detail.
> 
> Does anybody know how to find chipset docs for AMD/ATI chipsets? I find 
> CPU docs, and the GPU docs, but not the 790 chipset docs anywhere (yeah, 
> it looks promising with a link that says "AMD 790FX Chipset 
> Specifications", but the link just takes you to some trivial overview, not 
> any actual specs.
> 
> Anybody?

There are some at:
http://www.amd.com/us-en/Processors/TechnicalResources/0,,30_182_739_15137,00.html

Well, that's 690/SB600 only and I'm not sure how useful this is.

Thanks,
Rafael
