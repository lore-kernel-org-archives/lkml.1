Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXHWWdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXHWWdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933118AbXHWW3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49292 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbXHWW27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:59 -0400
Date: Thu, 23 Aug 2007 15:27:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, andre@finow14.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-Id: <20070823152736.fea4ddf7.randy.dunlap@oracle.com>
In-Reply-To: <20070823141116.87b10f84.akpm@linux-foundation.org>
References: <20070823125227.294913273@finow14.de>
	<20070823125540.GA19389@ahaupt-debian-vm.localdomain>
	<20070823131302.GA24870@lazybastard.org>
	<20070823141116.87b10f84.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 14:11:16 -0700 Andrew Morton wrote:

> On Thu, 23 Aug 2007 15:13:02 +0200
> Jörn Engel <joern@logfs.org> wrote:
> 
> > Trivial change in a comment.
> > 
> > Signed-off-by: Jörn Engel <joern@logfs.org>
> > Signed-off-by: Andre Haupt <andre@finow14.de>
> > ---
> > Index: linus/scripts/checkstack.pl
> > ===================================================================
> > --- linus.orig/scripts/checkstack.pl	2007-08-23 14:25:03.000000000 +0200
> > +++ linus/scripts/checkstack.pl	2007-08-23 14:42:13.000000000 +0200
> > @@ -14,7 +14,7 @@
> >  #	M68k port by Geert Uytterhoeven and Andreas Schwab
> >  #
> >  #	Usage:
> > -#	objdump -d vmlinux | stackcheck.pl [arch]
> > +#	objdump -d vmlinux | scripts/checkstack.pl [arch]
> >  #
> >  #	TODO :	Port to all architectures (one regex per arch)
> 
> Thanks, I forwarded this to Andy.  I prefer not to apply checkpatch
> patches directly to -mm as it's still under a considerable amount of
> development and anything which I apply would just get tangled up with
> Andy's next update.

That's checkstack, not checkpatch...

The patch is correct, but most people use it (checkstack) via
  make checkstack
AFAIK.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
