Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbXL3WAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbXL3WAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXL3WAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:00:41 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50227 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXL3WAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:00:41 -0500
Date: Sun, 30 Dec 2007 23:00:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 1/3] Remove unused dependency
Message-ID: <20071230220018.GA16557@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com> <1198306931-5258-2-git-send-email-joe@perches.com> <20071222083323.GA22653@uranus.ravnborg.org> <1198313412.4895.24.camel@localhost> <20071222143128.GA24659@uranus.ravnborg.org> <1198351691.4895.42.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198351691.4895.42.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 11:28:11AM -0800, Joe Perches wrote:
> On Sat, 2007-12-22 at 15:31 +0100, Sam Ravnborg wrote:
> > I looked at how inflate was used:
> >  
> > $ grep inflate */boot/Makefile
> > alpha/boot/Makefile:$(obj)/misc.o: lib/inflate.c
> > => redundandt dependency, can be deleted
> > A cleanup of all this is needed.
> 
> Perhaps it's better to move lib/inflate.c to the
> include path (include/lib ?) and convert the files that
> #include "(../)*lib/inflate.c" to
> #include <lib/inflate.c>?

Hi Joe.

Can you please remind me what problem you are actually trying to solve here.
Your current approach it not good - we do not want .c code in include/*
And what is wrong with the current include path?

Thanks,
	Sam
