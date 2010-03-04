Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0CDTdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:33:06 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:59604 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753581Ab0CDTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:33:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RmMPtDsReg4XnIewbrtT6fXsz7Y4+oX35Nx7FDkK3bG5Lkl4Cgd2Dr5CkxLa0KlismABtjyvbOXytTZ+++3+8VyUmhw+IkW+5OUdJiJrprU7V1E6Tf/WMNntQfI6i3T5;
Date: Thu, 4 Mar 2010 11:33:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304113306.6c4fd782@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	<20100304103655.0b14343f@jbarnes-piketon>
	<20100304103929.6eb81d45@jbarnes-piketon>
	<alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
	<20100304105624.70fe845e@jbarnes-piketon>
	<alpine.LFD.2.00.1003041101390.3751@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 11:08:07 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> The thing is, they clearly didn't even _try_ to make anything compatible. 
> See how all the ioctl numbers were moved around. 
> 
> And if you can't make if backwards compatible, at least you should make it 
> forwards-compatible. Is it even that? I don't know. I'm kind of afraid it 
> isn't. The new libdrm required for it certainly hasn't been pushed to 
> Fedora-12. Will it ever be? And if it is, can you still run an old kernel 
> on it?

Sure, but both kinds of compat come at a cost, a potentially large one
in this case, so why take it on before absolutely necessary?  I know
you can see both sides of this...

> And btw, I'd complain about breaking backwards compatibility even if it 
> wasn't just my own machine. I can pretty much guarantee that I'm not going 
> to be the only one hitting this issue.

Right, but OTOH it's a development driver.  If you're running Fedora,
things will work as long as you stick to the distro packages.  And if
you're building your own kernels, you ought to be taking care with
staging drivers, right?

> So practically speaking: what _do_ you suggest we do about all the 
> regressions this will cause?

Before this thread I thought the policy was "let people muddle through"
with staging drivers until their staging status is cleared.  If that's
not the case, then really what's the point of staging?  I'm sure there
are other examples of this type of breakage in staging drivers, though
admittedly nouveau is probably the biggest in terms of user interest.

-- 
Jesse Barnes, Intel Open Source Technology Center
