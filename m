Return-Path: <linux-kernel-owner+w=401wt.eu-S1764761AbXHWQIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764761AbXHWQIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 12:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762439AbXHWQIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 12:08:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20371 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760508AbXHWQIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 12:08:07 -0400
Date: Thu, 23 Aug 2007 09:06:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Adrian Bunk <bunk@kernel.org>, joern@wohnheim.fh-wedel.de,
       linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-Id: <20070823090641.cbc0e70e.randy.dunlap@oracle.com>
In-Reply-To: <20070823133529.GD24870@lazybastard.org>
References: <20070823125227.294913273@finow14.de>
	<20070823125540.GA19389@ahaupt-debian-vm.localdomain>
	<20070823132639.GN30705@stusta.de>
	<20070823133529.GD24870@lazybastard.org>
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

On Thu, 23 Aug 2007 15:35:29 +0200 Jörn Engel wrote:

> On Thu, 23 August 2007 15:26:39 +0200, Adrian Bunk wrote:
> > On Thu, Aug 23, 2007 at 02:55:40PM +0200, andre@finow14.de wrote:
> > > Signed-off-by: Andre Haupt <andre@finow14.de>
> > > ---
> > > Index: linus/scripts/checkstack.pl
> > > ===================================================================
> > > --- linus.orig/scripts/checkstack.pl	2007-08-23 14:25:03.000000000 +0200
> > > +++ linus/scripts/checkstack.pl	2007-08-23 14:42:13.000000000 +0200
> > > @@ -14,7 +14,7 @@
> > >  #	M68k port by Geert Uytterhoeven and Andreas Schwab
> > >  #
> > >  #	Usage:
> > > -#	objdump -d vmlinux | stackcheck.pl [arch]
> > > +#	objdump -d vmlinux | scripts/checkstack.pl [arch]
> > >...
> > 
> > "make checkstack" ?

Yes, "make help" already lists this and the other check* scripts.

> If you really care about this, send a patch.  An argument against it is
> that some people seem to use the script independently of the linux
> kernel.  Not sure if all of them copy the makefile logic as well.
> 
> Does it matter?



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
