Return-Path: <linux-kernel-owner+w=401wt.eu-S1751853AbXCQGnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbXCQGnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbXCQGnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:43:08 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58219 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbXCQGnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:43:07 -0400
Date: Sat, 17 Mar 2007 07:43:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
Message-ID: <20070317064340.GB26842@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070316141121.82ba7cb8.randy.dunlap@oracle.com> <20070316153957.232cf648.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316153957.232cf648.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 03:39:57PM -0700, Randy Dunlap wrote:
> On Fri, 16 Mar 2007 14:11:21 -0700 Randy Dunlap wrote:
> 
> > On Fri, 16 Mar 2007 09:33:54 -0700 (PDT) Linus Torvalds wrote:
> > 
> > > 
> > > I pushed out the -git trees yesterday, but then got distracted, so the 
> > > patches and tar-balls and the announcement got delayed until this morning. 
> > > Oops. I'm a scatter-brain.
> > 
> > allmodconfig on i386:
> > 
> > WARNING: "default_idle" [arch/i386/kernel/apm.ko] undefined!
> > WARNING: "machine_real_restart" [arch/i386/kernel/apm.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> Please ignore.
> 
> I think that this was the result of doing 'make allyesconfig && make all'
> followed by 'make allmodconfig && make all' without doing a 'make clean'
> between them.
But then we have a dependency error somewhere we need to track down.
I will try to test here.

	Sam
