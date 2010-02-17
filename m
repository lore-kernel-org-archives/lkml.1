Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab0BQCBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:01:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933955Ab0BQCBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:01:34 -0500
Date: Wed, 17 Feb 2010 13:01:03 +1100
From: Neil Brown <neilb@suse.de>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217130103.3ca65ef3@notabene.brown>
In-Reply-To: <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	<4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	<201002141940.35716.volkerarmin@googlemail.com>
	<4B7AD35E.7000405@tmr.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 16:03:43 -0900 (AKST)
"Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:

>  	Hello Bill ,
> 
> On Tue, 16 Feb 2010, Bill Davidsen wrote:
> > Volker Armin Hemmann wrote:
> >> On Sonntag 14 Februar 2010, you wrote:
> >>> In other words, 'auto-detection' for 1.x format devices is using an
> >>> initrd/initramfs.
> >>
> >> which makes 1.x format useless for everybody who does not want to deal with 
> >> initrd/initramfs.
> >
> > You make this sound like some major big deal. are you running your own 
> > distribution? In most cases mkinitrd does the right thing when you "make 
> > install" the kernel, and if you are doing something in the build so complex 
> > that it needs options, you really should understand the options and be sure 
> > you're doing what you want.
> >
> > Generally this involves preloading a module or two, and if you need it every 
> > time you probably should have built it in, anyway.
> >
> > My opinion...
>  	My Opinion as well .  That is one of the many reasons why I have my '/' 
> autoassemble .  And do to this I am permanently stuck at 0.90 version of the 
> raid table .  No big shakes for that .  But at sometime in the past there was a 
> discussion to have the 0.90 raid table be removed ,  NOW THAT SCARES THE H?LL 
> OUT OF ME .  So far Neil has not done so .
> 
>  	I am unaware of any record from Neil or other maintainer(s) of the 
> /md/ device tree saying that they will not remove the 0.90 table and the 
> autoassembly functions there .  I'd very much like to hear a statement saying 
> there will not be a removal of the autoassembly functions for 0.90 raid table 
> from the kernel tree .

I will not be removing 0.90 or auto-assemble from the kernel in the
foreseeable future.
None the less, I recommend weaning yourself from your dependence on it.
initramfs is the future, embrace it.

NeilBrown
