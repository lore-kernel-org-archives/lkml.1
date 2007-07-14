Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXGNHLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXGNHLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXGNHLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:11:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60762 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751891AbXGNHLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:11:03 -0400
Date: Sat, 14 Jul 2007 09:10:34 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup congestion control options
Message-ID: <20070714071034.GG3565@stusta.de>
References: <20070714040953.GE3565@stusta.de> <20070713.235442.75191469.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070713.235442.75191469.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 11:54:42PM -0700, David Miller wrote:
> From: Adrian Bunk <bunk@stusta.de>
> Date: Sat, 14 Jul 2007 06:09:54 +0200
> 
> > This patch contains the following cleanups:
> > - note in the prompt if an option depends on EXPERIMENTAL
> > - remove "default n"s that didn't have any effect
> > - remove "default m"s from options under TCP_CONG_ADVANCED:
> >   if you manually choose congestion control modules you should
> >   know which ones you want
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> I'm not so sure about any of this, sorry Adrian, I'm
> not applying this.

What exactly are you not sure of?
- noting the experimental status in the prompt is a common convention
  in the kernel
- "default n"s like here are nops serving no purpose

This leaves only the removal of the "default m"s which I thought would 
be non-controversial since people seeing these options should know best
what they need.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

