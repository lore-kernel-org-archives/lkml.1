Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbXEXWmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbXEXWmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXEXWlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:41:55 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44745 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753117AbXEXWly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:41:54 -0400
Date: Fri, 25 May 2007 00:41:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Rob Landley <rob@landley.net>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524224147.GF4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com> <200705241347.43727.rob@landley.net> <adahcq26r8p.fsf@cisco.com> <20070524180704.GE4470@stusta.de> <adawsyy5azc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adawsyy5azc.fsf@cisco.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 11:32:07AM -0700, Roland Dreier wrote:
>  > The problem is that inline functions in headers are intended to be 
>  > called from different C files.
>  > 
>  > gcc might not inline it in the C files where it is called more than 
>  > once.
>  > 
>  > But it will always inline it if it's called only once.
>  > 
>  > One of both will be suboptimal, but from gcc's perspective it was 
>  > optimal.
> 
> Yes, we could probably get huge benefits from --combine and/or
> -fwhole-program to let gcc see more than one file at a time.
> 
> But I still don't see the issue with having gcc do the best it can on
> each file it compiles.  If you force the inlining, then that means
> that on files where not inlining was better, you've forced gcc to
> generate worse code.  (I don't see how not inlining could be locally
> better on a single file but globally worse, even though it generated
> better code on each compiled file)

Can you give examples where for one function it differs between 
different C files whether it should be inlined or not?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

