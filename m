Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0CDSvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:51:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab0CDSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:51:31 -0500
Date: Thu, 4 Mar 2010 10:51:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <20100304103929.6eb81d45@jbarnes-piketon>
Message-ID: <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain> <20100304103655.0b14343f@jbarnes-piketon> <20100304103929.6eb81d45@jbarnes-piketon>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Jesse Barnes wrote:

> On Thu, 4 Mar 2010 10:36:55 -0800
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > Yes Dave probably should have mentioned it in his pull request, but
> > that doesn't seem to be a good reason not to pull imo...
> 
> And now I see Dave did mention this, so what gives.  Guidance please.

Yeah, it's in the first one. My bad. I didn't notice, because that one got 
cancelled for other reasons and never even tested.

That doesn't change the simple basic issue: how are people with Fedora-12 
going to test any kernel out now? And are there libdrm versions that can 
handle _both_ cases, so that people can bisect things? IOW, even if you 
have a new libdrm, will it then work with the _old_ kernel too?

Backwards compatibility is really important.

		Linus
