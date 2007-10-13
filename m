Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbXJMHfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbXJMHfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXJMHfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:35:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:56284 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753815AbXJMHfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:35:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18q16xUZckqM1ftng5hiuyh2dDw38RnVTZAXwzkaV
	O88pUSCNeTGlcN
Subject: Re: 2.6.23.git build error
From: Mike Galbraith <efault@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Giacomo Catenazzi <cate@debian.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071013071626.GA28168@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net>
	 <20071012213114.GA24016@uranus.ravnborg.org>
	 <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org>
	 <20071013071626.GA28168@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 09:35:09 +0200
Message-Id: <1192260909.7369.20.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-13 at 09:16 +0200, Sam Ravnborg wrote:

> Pulled 2.6.23 tree and did a build
> Added latest -linus on top of it.
> Did a new build (x86_64).
> 
> 
> As expected it failed due to wrong asm symlink but nothing
> like the error Mike posted.
> So I'm a bit puzzeled here.
> 
> I anyone can explain how to reproduce it I will chase it
> but otherwise it will be left as a "consequence of
> the x86 merge".

What I did was to pull, then diff against my working tree (/me=SCM
weenie;) for review as usual, and then apply that diff to working tree
and make oldconfig as usual.  That left me with the same failure this
morning, despite the file being verified present in the git tree.  I
then used git-archive --format=tar | (cd work_tree;tar -xvf -).  That
spewed chunks when I tried to build it even though diff said the trees
were identical.  After make mrproper and restoring my saved .config, all
was peachy.

Methinks dontdiff bit me.

	-Mike

