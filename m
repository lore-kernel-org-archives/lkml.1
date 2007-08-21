Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbXHUQVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbXHUQVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXHUQVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:21:37 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3171 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbXHUQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:21:36 -0400
Date: Tue, 21 Aug 2007 18:21:55 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andres Salomon <dilinger@queued.net>
cc: kbuild-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: UNS: Re: [PATCH] kconfig: add *_silentdefconfig feature for
 config targets
In-Reply-To: <20070821114129.fe2737b4.dilinger@queued.net>
Message-ID: <Pine.LNX.4.64.0708211809110.1817@scrub.home>
References: <20070820204020.7cde776e.dilinger@queued.net>
 <Pine.LNX.4.64.0708211717180.1817@scrub.home> <20070821114129.fe2737b4.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 21 Aug 2007, Andres Salomon wrote:

> > I would really like to avoid another input mode.
> > I think it be better to implement this as a combination of "-s -D 
> > <default>" and the silent mode is adjusted to read another config instead 
> > of .config if defconfig_file is set.
> > 
> 
> As would I; however, that requires using getopt() (or equivalent).  I wasn't
> sure if there was some opposition to this..

I'm not sure how getopt() would change much (besides changing the "if" to 
a "while"), but I don't really mind either way.

> Of course, we'll still need some way from the makefile to call it.  I take
> it you're not opposed to 'make foo_silentdefconfig'?

No, that part looks fine.

> > >   - We seem to switch between using _() and not using it for strings; I'm
> > >     assuming that we don't actually care about i18n in conf.c, and that the
> > >     _() stuff was just copied from elsewhere.  If that's not the case, I
> > >     can update the patch to wrap strings properly.
> > 
> > I try to keep this uptodate, but I don't really check for this.
> > 
> 
> I'm not sure I follow; should I use _(), or no?

It means I don't really care much about it, but _() should be properly 
used where needed.

bye, Roman
