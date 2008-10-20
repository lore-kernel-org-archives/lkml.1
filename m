Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYJTEsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYJTEsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYJTEr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:47:57 -0400
Received: from mail.skyusermail.com ([77.240.11.49]:4675 "EHLO
	mail.skyusermail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYJTEr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:47:57 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 00:47:56 EDT
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Steven J Newbury <steve@snewbury.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <1224438749.10548.62.camel@lappy.programming.kicks-ass.net>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
	 <1224295858.4378.8.camel@vonnegut.anholt.net>
	 <alpine.LFD.2.00.0810171941120.3438@nehalem.linux-foundation.org>
	 <1224316142.4378.17.camel@vonnegut.anholt.net>
	 <1224438749.10548.62.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 05:17:02 +0100
Message-Id: <1224476222.4676.5.camel@infinity.southview.snewbury.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 19:52 +0200, Peter Zijlstra wrote:
> On Sat, 2008-10-18 at 00:49 -0700, Eric Anholt wrote:
> 
> > Writing 3D drivers means running 3D games.  Running 3D games
> > unfortunately means running a lot of 32-bit userland as the fun stuff is
> > binary-only.  So I stick to a 32-bit system, becuase past experience
> > trying to run both on the same system has been misery.
> 
> You can run 32bit user-space on a 64bit kernel just fine.
> Any breakage, if anything, you find will need to get fixed anyway.
> 
I'd like to second this.  32bit on 64bit works fine.  I've been
maintaining separate multilib versions of the Gentoo libdrm/Mesa ebuilds
for 32bit/64bit.  It is important that the 32bit and 64bit graphics
stacks are synchronised, rather than relying on external compatibility
libraries as Gentoo does currently.  Failing to do so does lead to
instability and/or failure.
 
> Also, one would hope Intel is poking these game writers to migrate to
> 64bit Linux ;-)
> 
Indeed! :)

