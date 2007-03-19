Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXCSEeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXCSEeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 00:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933783AbXCSEeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 00:34:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49861 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbXCSEeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 00:34:11 -0400
Date: Sun, 18 Mar 2007 21:16:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Message-Id: <20070318211651.40d82aed.randy.dunlap@oracle.com>
In-Reply-To: <20070318123945.GA23953@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070316141121.82ba7cb8.randy.dunlap@oracle.com>
	<20070316153957.232cf648.randy.dunlap@oracle.com>
	<20070317064340.GB26842@uranus.ravnborg.org>
	<20070318123945.GA23953@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Mar 2007 13:39:45 +0100 Sam Ravnborg wrote:

> On Sat, Mar 17, 2007 at 07:43:40AM +0100, Sam Ravnborg wrote:
> > On Fri, Mar 16, 2007 at 03:39:57PM -0700, Randy Dunlap wrote:
> > > On Fri, 16 Mar 2007 14:11:21 -0700 Randy Dunlap wrote:
> > > 
> > > > On Fri, 16 Mar 2007 09:33:54 -0700 (PDT) Linus Torvalds wrote:
> > > > 
> > > > > 
> > > > > I pushed out the -git trees yesterday, but then got distracted, so the 
> > > > > patches and tar-balls and the announcement got delayed until this morning. 
> > > > > Oops. I'm a scatter-brain.
> > > > 
> > > > allmodconfig on i386:
> > > > 
> > > > WARNING: "default_idle" [arch/i386/kernel/apm.ko] undefined!
> > > > WARNING: "machine_real_restart" [arch/i386/kernel/apm.ko] undefined!
> > > > make[1]: *** [__modpost] Error 1
> > > > make: *** [modules] Error 2
> > > 
> > > Please ignore.
> > > 
> > > I think that this was the result of doing 'make allyesconfig && make all'
> > > followed by 'make allmodconfig && make all' without doing a 'make clean'
> > > between them.
> > But then we have a dependency error somewhere we need to track down.
> > I will try to test here.
> 
> So far no luck in reproducing this.
> I will await additional reports before looking more into this one.

Hi Sam,
It's reproducible for me.

(I'm on x86_64:)

make clean
make ARCH=i386 allyesconfig
make ARCH=i386 all
make ARCH=i386 allmodconfig
make ARCH=i386 all

What kind of debug info do you want/need on this?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
