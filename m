Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXJMHPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXJMHPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXJMHOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:14:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46101 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbXJMHOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:14:55 -0400
Date: Sat, 13 Oct 2007 09:16:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Giacomo Catenazzi <cate@debian.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.git build error
Message-ID: <20071013071626.GA28168@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net> <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47105A39.9070406@debian.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 07:40:09AM +0200, Giacomo Catenazzi wrote:
> Mike Galbraith wrote:
> > On Fri, 2007-10-12 at 23:31 +0200, Sam Ravnborg wrote:
> >> On Fri, Oct 12, 2007 at 06:48:58AM +0200, Mike Galbraith wrote:
> >>> Greetings,
> >>>
> >>> Freshly pulled 2.6.23.git failed to build:
> >>>
> >>> make[1]: *** No rule to make target `arch/x86/kernel/asm-offsets.c', needed by `arch/x86/kernel/asm-offsets.s'.  Stop.
> >>> make: *** [prepare0] Error 2
> >>> make: *** Waiting for unfinished jobs....
> >> You are the only reporter of this bug.
> >> I do not see it here and I have the asm-offset.c file.
> > 
> > Yeah, I noticed nobody else was griping.
> 
> 
> I also saw this behaiour, but make mrproper solved the problem.

Pulled 2.6.23 tree and did a build
Added latest -linus on top of it.
Did a new build (x86_64).


As expected it failed due to wrong asm symlink but nothing
like the error Mike posted.
So I'm a bit puzzeled here.

I anyone can explain how to reproduce it I will chase it
but otherwise it will be left as a "consequence of
the x86 merge".

	Sam
