Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXDMVJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXDMVJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXDMVJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:09:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52007 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030310AbXDMVJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:09:50 -0400
Date: Fri, 13 Apr 2007 23:10:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: make clean for DocBook
Message-ID: <20070413211039.GA18097@uranus.ravnborg.org>
References: <20070413090658.b4c4bc8f.randy.dunlap@oracle.com> <20070413164142.GA14706@uranus.ravnborg.org> <20070413112316.44141d34.randy.dunlap@oracle.com> <20070413193250.GA15361@uranus.ravnborg.org> <20070413140337.9ecba871.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413140337.9ecba871.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 02:03:37PM -0700, Randy Dunlap wrote:
> On Fri, 13 Apr 2007 21:32:50 +0200 Sam Ravnborg wrote:
> 
> > > > 
> > > > 
> > > > And we will visit DocBook with mrproper - but not clean.
> > > > I have no stron opinion when to delete generated files in DocBook.
> > > 
> > > OK, that's fine, thanks for the info...
> > > but trying 'make mrproper' gives me:
> > > 
> > > make -f scripts/Makefile.clean obj=Documentation/DocBook
> > > make -f scripts/Makefile.clean obj=Documentation/DocBook/man/
> > > make[2]: execvp: /bin/sh: Argument list too long
> > > make[2]: *** [__clean] Error 127
> > > make[1]: *** [Documentation/DocBook/man/] Error 2
> > > make: *** [_mrproper_Documentation/DocBook] Error 2
> > > 
> > > DocBook/man/ contains about 2000 files.
> > > Is there some way to have scripts/Makefile.clean just do
> > > 	rm -rf Documentation/DocBook/man/
> > > ?  or some other solution?
> > 
> > Something like this should do it.
> > This deletes the man/ directory entirely so
> > I have to do that when I check in the patch.
> > 
> > Let me know if this works for you.
> 
> Yes, thanks.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, pushed out to kbuild.git.

	Sam
