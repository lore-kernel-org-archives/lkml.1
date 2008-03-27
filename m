Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYC0Lzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYC0Lzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYC0LzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:55:11 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34339 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbYC0LzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:55:10 -0400
Date: Thu, 27 Mar 2008 13:54:59 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jan Dittmer <jdi@l4x.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327115459.GB1686@cs181133002.pp.htv.fi>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au> <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com> <20080327104745.GA1686@cs181133002.pp.htv.fi> <20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080327123226.452f0a3f@hskinnemo-gx620.norway.atmel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 12:32:26PM +0100, Haavard Skinnemoen wrote:
> On Thu, 27 Mar 2008 12:47:45 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > According to Jan's page, there's still a build error with the defconfig:
> >   http://l4x.org/k/?d=40450#err
> 
> Hmm...that must be a pretty ancient toolchain.

The oldest compiler the kernel currently supports is gcc 3.2, and 
whenever it's reasonably possible (noone expects you to backport avr32 
support to gcc 3.2) the aim is to support all compilers back to gcc 
3.2, or at least as far as possible.

> In any case, the patch
> below should fix it. The commit being reverted is not in mainline, so
> I'll probably just drop both of them next time I rebase.

Thanks.

> FWIW, a more recent toolchain is available here:
> 
> http://avr32linux.org/twiki/bin/view/Main/BinutilsPatches
> http://avr32linux.org/twiki/bin/view/Main/GccPatches

Jan (who runs this page) Cc'ed.

> Haavard

cu
Adrian

BTW: What's the status of avr32 support in upstream binutils and gcc?

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

