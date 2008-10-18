Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbYJRCre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbYJRCre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJRCr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:47:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbYJRCr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:47:26 -0400
Date: Fri, 17 Oct 2008 19:47:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
In-Reply-To: <1224295858.4378.8.camel@vonnegut.anholt.net>
Message-ID: <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>  <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org> <1224295858.4378.8.camel@vonnegut.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Eric Anholt wrote:
> 
> Yeah, none of us are on x86-64, so we missed those warnings in testing.

Really? None of you use any modern CPU's, or you're _all_ running 32-bit 
distros even though your cpu's could support 64-bit ones?

I would suggest at least _somebody_ in the intel graphics team try to get 
with the times.. I realize that Otellini was saying "Nobody needs 64-bit 
on the desktop" a few years ago, but he was full of sh*t then, and it's 
certainly not remotely true now.

It's not being disloyal to your CEO, really. I'm pretty sure nobody will 
be fired just for ignoring that whole "640kB^H^H^H^H^H32-bits should be 
enough for everybody" idiocy.

> The change looks pretty good except for s/return 1/return 0/.

oops, yes. Thinko. I reversed the meaning of the return value: at first I 
just returned "unwritten", but decided that that was a really ugly 
interface, and then when I prettied that up, I didn't fix the !HIGHMEM 
case. And I obviously never _tested_ it.

			Linus
