Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZI0IoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZI0IoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZI0IoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:44:08 -0400
Received: from [195.41.46.235] ([195.41.46.235]:48661 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZI0IoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:44:07 -0400
Date: Sun, 27 Sep 2009 10:44:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Am?rico Wang <xiyou.wangcong@gmail.com>, Caveh Jalali <ecaveh@gmail.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] warn about use of uninstalled kernel headers
Message-ID: <20090927084406.GD10177@merkur.ravnborg.org>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com> <20090918045259.GA23333@merkur.ravnborg.org> <200909211637.12983.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909211637.12983.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 04:37:12PM +0200, Arnd Bergmann wrote:
> On Friday 18 September 2009, Sam Ravnborg wrote:
> > > > I think we should no longer have the include2 directory at all with new kernels.
> > > >
> > > > LINUXINCLUDE already contains the right path in theory:
> > > >
> > > > LINUXINCLUDE    := -Iinclude \
> > > >                   $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> > > >                   -I$(srctree)/arch/$(hdr-arch)/include               \
> > > >                   -include include/linux/autoconf.h
> > > 
> > > Hmm, at least in mmotm, we still have include2...
> > > 
> > > Maybe Sam is queueing the patches to remove include2?
> > I have them queued - yes.
> > But as they never hit -next they will wait another cycle.
> 
> Variations of this are starting to turn into a FAQ. How about
> printing a useful warning when someone tries to use the kernel
> headers without installing them first?

OK - applied.

	Sam
