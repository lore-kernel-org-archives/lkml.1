Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0CDWyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:54:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313Ab0CDWyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:54:21 -0500
Date: Thu, 4 Mar 2010 14:54:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stephane Marchesin <stephane.marchesin@gmail.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>  <20100304185002.GA23532@srcf.ucam.org>  <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>  <20100304190450.GA23807@srcf.ucam.org>
  <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>  <20100304192524.GA24253@srcf.ucam.org>  <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>  <20100304195302.GA24856@srcf.ucam.org>  <alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
 <6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Stephane Marchesin wrote:
> 
> In short, the "don't break user space interfaces" principle is making
> user space code quality worse for everyone. And it makes our lives as
> graphics developers pretty miserable actually

And _my_ point is that if you did a half-way decent job on versioning, you 
wouldn't be in the crappy situation you are now.

For chissake, the DRM versioning model is a total disaster. The reason you 
can never ever break user space interfaces is exactly because when you 
break them, X stops working.

What I suggested is to _keep_ a working model across different versions, 
so that you can get out of the rat-hole you are in now (and the rat-hole 
you put your users into, and the distributions).

It's simply _not_ acceptable to tie the X server and the kernel version so 
tightly together as the crazy DRM model does right now. It's not all that 
different from us requiring people to install a new glibc every once in a 
while, just because we added a new filesystem. Everybody understands that 
that would be totally insane.

Why does the X community not understand simple library versioning?

			Linus
