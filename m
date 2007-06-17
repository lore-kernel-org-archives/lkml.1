Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXFQAob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXFQAob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 20:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbXFQAoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 20:44:24 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37123 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756252AbXFQAoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 20:44:23 -0400
Date: Sun, 17 Jun 2007 02:44:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Message-ID: <20070617004436.GU3588@stusta.de>
References: <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <200704291849.23197.rjw@sisk.pl> <20070429173725.GB30248@one.firstfloor.org> <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4673D63D.5020804@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 02:23:25PM +0200, Stefan Richter wrote:
>...
> [Adrian, I'm not saying "too few users run -rc kernels", I'm saying "too
> few FireWire driver users run -rc kernels".]

Getting more people testing -rc kernels might be possible, and I don't 
think it would be too hard. And not only FireWire would benefit from 
this, remember e.g. that at least 2 out of the last 5 kernels Linus 
released contained filesystem corruption regressions.

The problem is that we aren't able to handle the many regression reports 
we get today, so asking for more testing and regression reports today 
would attack it at the wrong part of the chain.

Additionally, every reported and unhandled regression will frustrate the 
reporter - never forget that we have _many_ unhandled bug reports 
(including but not limited to regression reports) where the submitter 
spent much time and energy in writing a good bug report.

If we somehow gain the missing manpower for debugging regressions we can 
actively ask for more testing. Missing manpower (of people knowing some 
part of the kernel well) for debugging bug reports is IMHO the one big 
source of quality problems in the Linux kernel. If we get this solved, 
things like getting more testers for -rc kernels will become low hanging 
fruits.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

