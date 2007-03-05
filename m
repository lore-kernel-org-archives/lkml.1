Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbXCEC0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbXCEC0E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXCEC0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:26:04 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50080 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752582AbXCEC0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:26:02 -0500
Date: Mon, 5 Mar 2007 03:26:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, vonbrand@inf.utfsm.cl,
       davem@sunset.davemloft.net, sparclinux@vger.kernel.org
Subject: Re: [6/6] 2.6.21-rc2: known regressions
Message-ID: <20070305022602.GL3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015045.GK3441@stusta.de> <20070304.180725.126592830.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070304.180725.126592830.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 06:07:25PM -0800, David Miller wrote:
> From: Adrian Bunk <bunk@stusta.de>
> Date: Mon, 5 Mar 2007 02:50:45 +0100
> 
> > Subject    : sparc64 compile error due to GENERIC_ISA_DMA removal
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8097
> > Submitter  : Horst H. von Brand <vonbrand@inf.utfsm.cl>
> > Caused-By  : David S. Miller <davem@sunset.davemloft.net>
> >              commit 1b51d3a08b6c80a1e47d4c579c41abbe56cd3c44
> > Status     : unknown
> 
> Fixed in current GIT.
> 
> commit 74bd7d093b8e87f35eaf3b14459b96a0e20d1d10
> Author: David S. Miller <davem@sunset.davemloft.net>
> Date:   Wed Feb 28 13:09:34 2007 -0800
> 
>     [SPARC64]: Fix parport_pc build.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Horst's problem is with the floppy driver and 
claim_dma_lock/release_dma_lock in include/asm-sparc64/dma.h .

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

