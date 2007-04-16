Return-Path: <linux-kernel-owner+w=401wt.eu-S1030673AbXDPOgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030673AbXDPOgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXDPOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:36:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52141 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030673AbXDPOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:36:05 -0400
Date: Mon, 16 Apr 2007 16:36:13 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mike Mattie <codermattie@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: Re: [BUG] 2.6.21-rc7 hpt366 driver broken
Message-ID: <20070416143613.GD10338@stusta.de>
References: <20070415224846.52a465b6@reforged> <20070416043822.0ea2490e@reforged>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070416043822.0ea2490e@reforged>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Cc's added, full bug report was in http://lkml.org/lkml/2007/4/16/18 ]

On Mon, Apr 16, 2007 at 04:38:22AM -0700, Mike Mattie wrote:
> On Sun, 15 Apr 2007 22:48:46 -0700
> Mike Mattie <codermattie@gmail.com> wrote:
> 
> > Hello,
> > 
> > I am testing the 2.6.21-rc7 kernel release. The IDE hpt366 driver is
> > crashing hanging the boot. I have basically the same config as
> > 2.6.20.7 which works fine (except for netconsole mentioned in a
> > previous mail).
> > 
> > here is the hand-copied info:
> > 
> > * "unable to handle paging request" , null deref
> > * EIP @ init_chipset_hpt366
> > 
> 
> > I am running a git-bisect to see if I can resolve it to a commit.
> 
> This was identified as the first broken commit:
> 
> commit 7b73ee05d0acb926923d43d78b61add776ea4bb1
> Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Date:   Wed Feb 7 18:18:16 2007 +0100
> 
>     hpt366: init code rewrite
> 
> Reverting is conflicted so it will be a bit longer before I pin-point any other build-breaks.

Thanks for your report.

Can you use a digital camera for taking a photograph of the crash?

cu
Adrian

--

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

