Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYDZPW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYDZPW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYDZPWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:22:19 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:56018 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYDZPWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:22:17 -0400
Date: Sat, 26 Apr 2008 17:21:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in
 header file
In-Reply-To: <20080426150030.GH2252@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804261720060.2756@ask.diku.dk>
References: <20080426134554.GA20727@damson.getinternet.no>
 <20080426150030.GH2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2008, Adrian Bunk wrote:

> On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> > Hi Sam,
> > 
> > Maybe something like this could be useful for cleaning up headers (and
> > maintaining that cleanliness once it has been achieved). What do you think?
> > 
> > (One thing which might or might not be good is that 'make headerdep' will
> >  also compile using CC if they're not already compiled. If this should be
> >  fixed, I think you'd know how to do it.)
> 
> This way you only catch problems in the current kernel configuration.
> 
> The only problems are under include/, and you should be able to do this 
> by parsing all headers and without hooking into the build system.

I guess one would still have to consider all of the possible permutations 
of values of configuration variables, to interpret the #ifdefs that have 
an impact on what is included?  A quick grep suggests that they are mostly 
related to  __KERNEL__, so perhaps it would not be too expensive to do.

julia

