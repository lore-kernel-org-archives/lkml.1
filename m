Return-Path: <linux-kernel-owner+w=401wt.eu-S1764124AbXHWNju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764124AbXHWNju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXHWNjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:39:43 -0400
Received: from lazybastard.de ([212.112.238.170]:57358 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXHWNjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:39:42 -0400
Date: Thu, 23 Aug 2007 15:35:29 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: joern@wohnheim.fh-wedel.de, linux-kernel@vger.kernel.org,
       Andre Haupt <andre@finow14.de>
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-ID: <20070823133529.GD24870@lazybastard.org>
References: <20070823125227.294913273@finow14.de> <20070823125540.GA19389@ahaupt-debian-vm.localdomain> <20070823132639.GN30705@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070823132639.GN30705@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 August 2007 15:26:39 +0200, Adrian Bunk wrote:
> On Thu, Aug 23, 2007 at 02:55:40PM +0200, andre@finow14.de wrote:
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
> >...
> 
> "make checkstack" ?

If you really care about this, send a patch.  An argument against it is
that some people seem to use the script independently of the linux
kernel.  Not sure if all of them copy the makefile logic as well.

Does it matter?

Jörn

-- 
Anything that can go wrong, will.
-- Finagle's Law
