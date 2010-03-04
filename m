Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0CDS4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:56:22 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:34605 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756147Ab0CDS4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:56:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mpeWWwdEtSEaaQvGQSUrQTnM84jxjf6MI293MzUOmJMagf6OCMdXgPd20PKyKKJ1qJStYgD7hUwVZNOxfWE04FFQRWI4N349fE17+hA8vZQIOydJljjG3ZSfeHQyb3Vb;
Date: Thu, 4 Mar 2010 10:56:24 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304105624.70fe845e@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	<20100304103655.0b14343f@jbarnes-piketon>
	<20100304103929.6eb81d45@jbarnes-piketon>
	<alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 10:51:20 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 4 Mar 2010, Jesse Barnes wrote:
> 
> > On Thu, 4 Mar 2010 10:36:55 -0800
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > Yes Dave probably should have mentioned it in his pull request, but
> > > that doesn't seem to be a good reason not to pull imo...
> > 
> > And now I see Dave did mention this, so what gives.  Guidance please.
> 
> Yeah, it's in the first one. My bad. I didn't notice, because that one got 
> cancelled for other reasons and never even tested.
> 
> That doesn't change the simple basic issue: how are people with Fedora-12 
> going to test any kernel out now? And are there libdrm versions that can 
> handle _both_ cases, so that people can bisect things? IOW, even if you 
> have a new libdrm, will it then work with the _old_ kernel too?
> 
> Backwards compatibility is really important.

Sure it is.  But OTOH this is very clearly a "use at your own risk"
driver.  Dave and the nouveau guys include the driver in Fedora to get
much needed test coverage, and make sure the latest bits in rawhide
work together.

The "use at your own risk" part is that you get to keep both pieces if
you try to mix and match kernels and userspace until the STAGING
moniker is removed.

If marking the driver as staging doesn't allow them to break ABI when
they need to, then it seems like they'll have no choice but to either
remove the driver from upstream and only submit it when the ABI is
stable, or fork the driver and submit a new one only when the ABI is
stable.  Neither seem particularly attractive.

Of course I'm implicitly trusting their motivation for breaking ABI in
this case, but that was very much a part of the merge discussion so
shouldn't come as a surprise to anyone.

-- 
Jesse Barnes, Intel Open Source Technology Center
