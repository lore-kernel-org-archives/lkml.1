Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYG2V7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYG2V7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYG2V73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:59:29 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:11586 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbYG2V72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:59:28 -0400
Date: Tue, 29 Jul 2008 23:59:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.27-rc1
Message-ID: <20080729215942.GA22760@uranus.ravnborg.org>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <20080729213746.GA22548@uranus.ravnborg.org> <alpine.LFD.1.10.0807291439270.3334@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807291439270.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:42:00PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 Jul 2008, Sam Ravnborg wrote:
> > 
> > But will you accept this stuff now or will we have to wait until
> > next merge window?
> 
> if the patches are really small adn the resulting build is well tested 
> (ignoring the actual _move_ operation), I'm ok with taking them.

For arm the actual diff is:
 Makefile                 |   20 +++++++-------------
 boot/compressed/Makefile |    3 ---
 tools/Makefile           |    1 +
 3 files changed, 8 insertions(+), 16 deletions(-)

But on top of this there are ~600 files that needed a
replacement of:
#include <asm/arch/foo.h>
to
#include <arch/foo.h>

So maybe not such a minimal patch - because I wanted to drop all
the symlink stuff.

> 
> In fact, in many ways I'd _prefer_ to do it now, rather than have it 
> pending and then do it durign the next merge window when there are a lot 
> of non-movement changes too.
> 
> > Now is a good time as development just started for next kernel.
> > And testing is simple - does it build?
> 
> Well, simple and simple. I'd love to see x86 done, but you yourself said 
> you haven't even dared look at UM. Which is the thing that is most likely 
> to have odd build things with direct symlinks etc.
> 
> (But I haven't looked either. Maybe I'm wrong, and it's all trivial).
um i never trivial :-(
But I will give it a try - but I have to sleep first.

	Sam
