Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYIVSAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYIVSAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYIVSAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:00:05 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:57998 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751652AbYIVSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:00:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=pnvpMsnL4bHjnKhhiYjc3yXtKYrTLnOYY6QYl/qDMQo6YbGbTpEx7ZsQicNxhwX7mcUayGZPgpZYo6Pfz4HqsFqIlXwqt6N1aNh7rv7MZaXuzPq+yFQ9iIV3dFmFLtP9;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] Export kmap_atomic_pfn for DRM-GEM.
Date: Mon, 22 Sep 2008 10:59:54 -0700
User-Agent: KMail/1.9.9
Cc: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@gmail.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1219779789-8368-1-git-send-email-eric@anholt.net> <1219855961.4994.6.camel@vonnegut.anholt.net> <200808281022.14296.nickpiggin@yahoo.com.au>
In-Reply-To: <200808281022.14296.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221059.54779.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2008 5:22 pm Nick Piggin wrote:
> > However, when other DRM drivers get around to doing memory management,
> > I'm sure they'll also be interested in an ioremap_wc that doesn't eat
> > ipi costs.  For us, the ipis for flushing were eating over 10% of CPU
> > time.  If your patch series cuts that cost, we could drop this piece at
> > that point.
>
> It can cut the cost quite significantly on normal vmap/vunmap loads I
> tested. Whether it will work as well on your workload, I don't know
> but I would have liked to find out. I raised this issue quite a while
> back, so I'm disappointed it had not been tried...

I think Eric has code with the vmap changes now?

Given our discussions at KS/Plumbers would you be ok with acking these 
patches?  Or do you want a repost so you can check out the vmap stuff?

After talking a bit more about it, I think we agreed that the ioctl interface 
is actually a better approach then trying to shoehorn this stuff into system 
calls, so aside from the vmap code (which could be done in 2.6.29 or whenever 
the vmap stuff lands) I think this patchset is pretty close to what we want 
in drm-next now...

Thanks,
Jesse
