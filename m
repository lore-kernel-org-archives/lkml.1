Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0CDTlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:41:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab0CDTlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:41:36 -0500
Date: Thu, 4 Mar 2010 11:41:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304192524.GA24253@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1003041131490.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain> <20100304185002.GA23532@srcf.ucam.org> <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
 <20100304190450.GA23807@srcf.ucam.org> <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain> <20100304192524.GA24253@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Matthew Garrett wrote:
> 
> You're asking volunteers who didn't ask for their driver to be merged to 
> perform more work in order to support users they didn't ask for.

And _you_ are making excuses for BAD TECHNICAL DECISIONS!

Come on! How hard is it to admit that that the change was done badly? How 
hard is it to admit that this isn't a political issue, it's about pure 
technology. There are good ways of doing things, and there are way sof 
doing things badly. 

I'm pointing to real _technical_ problems with how this was done. I'm 
talking about how this hurts testing, and how we've been able to handle 
things in other cases (with versioning, and forwards- or backwards- 
compatibility) without this kind of crap.

If you can't handle backwards compatibility - fine. But I get the very 
strong feeling that people didn't even _think_ about trying to be at least 
forwards-compatible, and I'm getting the _very_ strong feeling that you 
are making excuses for bad technology.

Is there some model of versioning inside X _except_ for the "it won't 
work" kind of thing? Can we fix this going forward, so that you can have 
_real_ versioning (ie multiple installed versions of a libdrm, the way you 
can have concurrently multiple installed versions of glibc?)

IOW, we have a real technical problem here. Are you just going to continue 
to make excuses about it?

			Linus
