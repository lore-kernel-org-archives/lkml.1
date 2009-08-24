Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZHXTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZHXTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZHXTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:53:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbZHXTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:53:34 -0400
Date: Mon, 24 Aug 2009 12:52:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Russell King <rmk@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Nicolas Pitre <nico@cam.org>,
       linux-kernel@vger.kernel.org, linux-arm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: ARM subarch submissions for next merge window
In-Reply-To: <877hwtnxdx.fsf@deeprootsystems.com>
Message-ID: <alpine.LFD.2.01.0908241249200.3158@localhost.localdomain>
References: <877hwtnxdx.fsf@deeprootsystems.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Aug 2009, Kevin Hilman wrote:
> 
> After some discussions on linux-arm-kernel during the last merge
> window, a suggestion from Alan Cox[1], and a willingness to try it
> from Russell[2], some ARM subarch maintainers would like to push our
> platform-specific code directly to you for the next merge window.
> 
> Any changes that affect common ARM code will still be pushed via
> Russell, only our platform-specific code will be submitted directly.
> 
> Also our platform code is still posted and reviewed on
> linux-arm-kernel as well as being included in linux-next. Only the
> merge path will change slightly.
> 
> Any problems with this?

I don't have any issues with it, as long as the subarch trees are clean 
and clear.

Part of that is the normal "git cleanliness" issue in general (ie I don't 
want to see ugly back-merges of my random kernel-of-the-day or see that 
something was rebased just five minutes ago and clearly had no testing), 
but the other part is obviously that if there then ends up being 
complaints where people end up stepping on each others toes, I would want 
a top-level maintainer to step in.

But I guess that as long as it's clearly just platform-specific files, 
that won't be a problem.

		Linus
