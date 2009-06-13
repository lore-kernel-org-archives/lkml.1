Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZFMWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZFMWIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZFMWIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 18:08:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbZFMWIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 18:08:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: references to non-existent header files under include/linux
Date: Sun, 14 Jun 2009 00:08:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0906130932570.16165@localhost> <20090613134947.GA30053@uranus.ravnborg.org> <alpine.LFD.2.00.0906131042440.17932@localhost>
In-Reply-To: <alpine.LFD.2.00.0906131042440.17932@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906140008.47553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Robert P. J. Day wrote:
> On Sat, 13 Jun 2009, Sam Ravnborg wrote:
> 
> > On Sat, Jun 13, 2009 at 09:35:42AM -0400, Robert P. J. Day wrote:
> > >
> > >   again, since this output is fairly short, this is a list of
> > > references throughout the source tree of the form:
> > >
> > >   #include <linux/whatever>
> > >
> > > where there does not appear to be any such header file.  might be some
> > > false positives but i'm not going to agonize over it.
> > >
> > >
> > > === Missing: include/linux/bounds.h ===
> > > include/linux/mmzone.h:18:#include <linux/bounds.h>
> > > include/linux/page-flags.h:11:#include <linux/bounds.h>
> > bounds.h is generated.
> >
> > > === Missing: include/linux/compile.h ===
> > > arch/x86/boot/version.c:17:#include <linux/compile.h>
> > > init/version.c:9:#include <linux/compile.h>
> > compile.h is generated.
> 
>   which i would have recognized if i hadn't been reduced to drinking
> decaf this morning.  *sigh*.
> 
> > The rest looks like real bugs.
> > Please submit patches to fix them up.
> 
>   these days, i'm more partial to just doing the scan and, when the
> official time comes, passing off the results to the various subsystem
> maintainers, only because sometimes it's not immediately obvious what
> the correct fix is.
> 
>   maybe it's a typo, maybe it's a partial feature commit where the
> code should include the header file but the header file is yet to be
> added, maybe it's part of code that is no longer even being compiled
> due to changes in #ifdef's or Kconfig files, maybe it's for a
> non-intel arch that i'm not set up to test, maybe ... anyway, you get
> the idea.  and, in some cases, when the subsystem maintainer takes a
> look at it, it might be that that single incorrect line represents a
> much larger issue that only that maintainer should deal with.
> 
>   in short, i'll just be lazy and whine, and let others do the actual
> fixing.  :-)

Well, I'm afraid that's not going to work out very well.

Best,
Rafael
