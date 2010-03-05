Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0CEKAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:00:21 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41574 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0CEKAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O7F86JJ0Yn7XLfBcCuo4VC7gksBBl8iHrdZThIrqZ4QnyrG8Up/xRiwKKcSATc+7Kk
         dEsyp/CyjHzxqX/8y8vbYS3ci1wsnfSfiaSTLmYRkqyjQKGtzClBLMnTL/HrfbZKGIOW
         CM6EuHPdc/ONsgqPZPxn2fMVGSPcnE8UqwE1E=
Date: Fri, 5 Mar 2010 11:00:30 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ben Skeggs <skeggsb@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Making Xorg easier to test (was Re: [git pull] drm request 3)
Message-ID: <20100305100030.GA4970@Pilar.aei.mpg.de>
References: <20100304105624.70fe845e@jbarnes-piketon>
 <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
 <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>
 <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain>
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
 <1267748927.3496.6.camel@nisroch>
 <20100305064955.GA6453@elte.hu>
 <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com>
 <20100305074407.GC19703@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305074407.GC19703@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  5.Mar'10 at  8:44:07 +0100, Ingo Molnar wrote:
> 
> Yeah. I've seen a few other bad arguments as well:
> 
>    'exploding test matrix'
> 
> This is often the result of _another_ bad technical decision: 
> over-modularization.
> 
> Xorg, mesa/libdrm and the kernel DRM drivers pretty share this signature:

I agree 100% with this!

I test the kernel often (running 2.6.33-05070-g64ba992 ATM) because
it is _easy_ for me. Every morning I simply do a 'git pull' + compile + install 
and I am ready to test the bleeding edge kernel. 
And everytime I complained about something breaking it got fixed.

Really, testing the linux kernel is a hobby for me because it is easy.

Whereas everytime I wanted to do that with Xorg it was such a pain that
I want to keep away from that mess.
 
>  - it's developed by the same tightly knit developer base who often cross
>    between these packages. Features often need changes in each component.
> 
>  - a developer to be able to do real work has to have the latest sources
>    of all these components.
> 
>  - a user just uses whatever horizontal version cut the distro did and never
>    truly 'mixes' these components as a conscious decision.

True!

Why can't there be a 'Linus Torvalds' for Xorg accepting patches from various
maintainers and keeping the whole thing tied up? Why can't it mimic the
'make menuconfig' way of selecting what to compile to have the guarantee that 
the whole thing will simply work nicely together?

If this could be done for the kernel (which from my user POV seems much more
complicated), I guess it could be done with Xorg. And Linux would have
more Xorg testers and be better as a whole.

