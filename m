Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0CEAmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:42:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab0CEAmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:42:02 -0500
Date: Thu, 4 Mar 2010 16:41:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ben Skeggs <skeggsb@gmail.com>
cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <1267748927.3496.6.camel@nisroch>
Message-ID: <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <20100304103655.0b14343f@jbarnes-piketon>  <20100304103929.6eb81d45@jbarnes-piketon>  <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
  <20100304105624.70fe845e@jbarnes-piketon>  <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>  <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com>  <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> 
 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>  <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Mar 2010, Ben Skeggs wrote:
> 
> The idea of staging was to allow for exactly the second problem, so why
> are you surprised?  The fact Fedora ships nouveau is irrelevant, we also
> expect that for the most part people will be using our packages, which
> deal with the ABI issues.

The fact that Fedora ships nouveau is _not_ irrelevant.

That fact was what made it so important to get it merged. The distro rules 
wrt the kernel have been (for _years_ - before nouveau was ever even used 
by Fedora) that whole "upstream first".

I don't understand how you can even call it irrelevant. The very fact that 
Fedora started using Nouveau was - and is - the whole reason for this 
issue. 

> > I'm not going to release a kernel that I can't test. So if I can't get a 
> > libdrm that works in my F12 environment, I will _have_ to revert that 
> > patch that you asked me to merge.
>
> The F13 packages *will* work, so long as you're not bisecting back and
> forth.

How do I install just the F13 libdrm thing, without changing everything 
else? I'm willing to try. We can make it part of the 2.6.34 release notes.

And if we end up having people bisecting back and forth, I will hate that 
f*cking nouveau driver even more.

				Linus
