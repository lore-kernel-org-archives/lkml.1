Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZJKJGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZJKJGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZJKJGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:06:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56628 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZJKJGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:06:13 -0400
Date: Sun, 11 Oct 2009 11:05:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091011090528.GD1414@ucw.cz>
References: <20091003103441.GA10874@elte.hu> <1255078731.17055.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255078731.17055.39.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-10-09 10:58:51, Peter Zijlstra wrote:
> On Sat, 2009-10-03 at 12:34 +0200, Ingo Molnar wrote:
> > 
> > that arch-cache thing introduced in:
> > 
> >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > 
> > isnt working very well in my experience.
> 
> Its breaking things for me too. When I build a .config using distcc and
> cross compilers on my build farm, and then try a make install on another
> machine which doesn't have either it utterly shits itself.

Well, I use CROSS_COMPILE="ccache " (note the space), and that breaks
build in a way where not even mrproper helps...  

> Please revert this.

Please do.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
