Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJXWwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJXWwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJXWw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:52:27 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45452 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYJXWw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:52:27 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 18:52:26 EDT
Date: Sat, 25 Oct 2008 00:51:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, alistair@devzero.co.uk, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024225121.GA19759@uranus.ravnborg.org>
References: <200810241345.04966.rjw@sisk.pl> <200810241352.45745.alistair@devzero.co.uk> <alpine.LFD.2.00.0810240801540.3287@nehalem.linux-foundation.org> <20081024.153139.36591021.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024.153139.36591021.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 03:31:39PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 24 Oct 2008 08:17:53 -0700 (PDT)
> 
> > Now, _another_ part (and arguably the really core reason) of this problem 
> > is that our Makefile rules for the asm include directory is weak and 
> > unreliable in the presense of already-existing unexpected entries.
> 
> I guess we could use seperate "stamp" files to deal with this.
> 
> Along with the generated file "foo" there is a "foo.stamp" file
> that is generated with "touch" after "foo" is built.

I remember I made an attempt doing so long time ago for
the asm symlink. But why it failed for me I dunno.

We used this trick in many archs before
but as part of the header move to arch/$ARCH we have killed
almost all uses of symlink to reach certain files.

The asm symlink is only used by asm-offsett.h for most archs these
days and when I get around to it I will fix that too so we
can kill it entirely.

But first we need to move all archs headers to arch/$ARCH.
And we are getting there.

	Sam
