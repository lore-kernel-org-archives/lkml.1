Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYJTQcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYJTQcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJTQcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:32:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbYJTQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:32:45 -0400
Date: Mon, 20 Oct 2008 09:31:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm patches for 2.6.27-rc1
In-Reply-To: <1224316142.4378.17.camel@vonnegut.anholt.net>
Message-ID: <alpine.LFD.2.00.0810200929360.3518@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>  <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>  <1224295858.4378.8.camel@vonnegut.anholt.net>  <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
 <1224316142.4378.17.camel@vonnegut.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Oct 2008, Eric Anholt wrote:
>
> > It's not being disloyal to your CEO, really. I'm pretty sure nobody will 
> > be fired just for ignoring that whole "640kB^H^H^H^H^H32-bits should be 
> > enough for everybody" idiocy.
> 
> Writing 3D drivers means running 3D games.  Running 3D games
> unfortunately means running a lot of 32-bit userland as the fun stuff is
> binary-only.

That's not a very good reason, though. We're supposed to be perfectly 
binary compatible, so it would actually be *better* if you did the testing 
using a 64-bit kernel.

Sure, don't do it on _all_ machines, but running 32-bit user land is 
definitely not a valid reason to avoid a 64-bit kernel. Quite the reverse. 
We'd like to see more coverage.

			Linus
