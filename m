Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbXGaORt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbXGaORt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760523AbXGaOR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:17:26 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:49849 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761820AbXGaORX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:17:23 -0400
Subject: Re: regression on HP zx1 platform from ACPI autoload modules
	patches - PATCH that fixes it
From: Doug Chapman <doug.chapman@hp.com>
To: trenn@suse.de
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <1185886862.18821.168.camel@queen.suse.de>
References: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
	 <6bffcb0e0707301607x5484f114q9117007d131f7118@mail.gmail.com>
	 <1185883574.14987.6.camel@athlon>
	 <1185886862.18821.168.camel@queen.suse.de>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 10:04:31 -0400
Message-Id: <1185890671.4478.0.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 15:01 +0200, Thomas Renninger wrote:
> On Tue, 2007-07-31 at 08:06 -0400, Doug Chapman wrote:
> > On Tue, 2007-07-31 at 01:07 +0200, Michal Piotrowski wrote:
> > > Hi Doug,
> > > 
> > > On 31/07/07, Doug Chapman <doug.chapman@hp.com> wrote:
> > > > I am seeing a regression on the HP ia64 zx1 platforms when using
> > > > a .config with CONFIG_IA64_HP_ZX1=y.  Oddly it works OK with
> > > > CONFIG_IA64_GENERIC=y.
> > > >
> > > >
> > > > During bootup it panics with:
> > > >
> > > > Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel
> > > >
> > > > I can provide the full console output if that is helpful.
> > > 
> > > Yes, it is very useful.
> > > 
> > > >  Also, please let
> > > > me know if there is any other data I can provide that would be helpful.
> > > 
> > > Kernel .config file.
> > 
> > 
> > Michal,
> > 
> > Attached are the full console output up to the panic and the .config
> > file I used to build the kernel.  Let me know if there is anything else
> > you need or if you would like me to try a patch.
> 
> This patch should fix it.
> It's already sent to Len. Bjorn/Myron already tested this one and gave
> an acked-by, but it has not hit Len's git tree yet.
> Len?
> Or should it be picked up by an IA64 tree?
> 
>    Thomas

Thomas,

I have confirmed this fixes my issue.

thanks,

- Doug


