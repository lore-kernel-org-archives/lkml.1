Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0CDXFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:05:16 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:48527 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754137Ab0CDXFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:05:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ja9IXkQC3/UKv8OFmcRqHkLnwiypkmA9zWlJ/KgflLZ1KTbftqm6Zfr/SzHclFx3rrB9DZob/eV7p2k1Qi1ZL8MdQtsLtF5QmWobZZgoVnDNFQtvA9Qj4II48R07V6dK;
Date: Thu, 4 Mar 2010 15:05:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Dave Airlie <airlied@linux.ie>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304150519.7d7345b0@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	<20100304185002.GA23532@srcf.ucam.org>
	<alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	<20100304190450.GA23807@srcf.ucam.org>
	<alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	<20100304192524.GA24253@srcf.ucam.org>
	<alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
	<20100304195302.GA24856@srcf.ucam.org>
	<alpine.LFD.2.00.1003041202240.3751@localhost.localdomain>
	<6a89f9d51003041257j39fde3b6y8bd3336d77f7cf7a@mail.gmail.com>
	<alpine.LFD.2.00.1003041449380.3751@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 14:54:03 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 4 Mar 2010, Stephane Marchesin wrote:
> > 
> > In short, the "don't break user space interfaces" principle is making
> > user space code quality worse for everyone. And it makes our lives as
> > graphics developers pretty miserable actually
> 
> And _my_ point is that if you did a half-way decent job on versioning, you 
> wouldn't be in the crappy situation you are now.
> 
> For chissake, the DRM versioning model is a total disaster. The reason you 
> can never ever break user space interfaces is exactly because when you 
> break them, X stops working.
> 
> What I suggested is to _keep_ a working model across different versions, 
> so that you can get out of the rat-hole you are in now (and the rat-hole 
> you put your users into, and the distributions).
> 
> It's simply _not_ acceptable to tie the X server and the kernel version so 
> tightly together as the crazy DRM model does right now. It's not all that 
> different from us requiring people to install a new glibc every once in a 
> while, just because we added a new filesystem. Everybody understands that 
> that would be totally insane.
> 
> Why does the X community not understand simple library versioning?

We use versioning on the Intel side, but in the form of feature flags
as new things are added (we've had a handful since GEM was added in
2.6.28).  It's a pain to handle the various code paths, but no more so
than having lots of separate library versions to support.  That would
be nice from one perspective, but it would only save work if we
abandoned the old versions quickly and kept a big shared component
between library versions.

-- 
Jesse Barnes, Intel Open Source Technology Center
