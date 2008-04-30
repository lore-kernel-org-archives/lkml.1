Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbYD3SsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbYD3SsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbYD3SsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:48:13 -0400
Received: from xenotime.net ([66.160.160.81]:44939 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750884AbYD3SsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:48:12 -0400
Date: Wed, 30 Apr 2008 11:48:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mporter@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] docbook: fix fatal rapidio yet again (and more to come)
Message-Id: <20080430114808.64e2f40b.rdunlap@xenotime.net>
In-Reply-To: <20080430113500.dfe21880.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net>
	<20080430113500.dfe21880.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 11:35:00 -0700 Andrew Morton wrote:

> On Tue, 29 Apr 2008 20:10:55 -0700 (PDT)
> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Don't refer to file that no longer exists:
> > docproc: linux-2.6.25-git14/arch/powerpc/kernel/rio.c: No such file or directory
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  Documentation/DocBook/rapidio.tmpl |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > --- linux-2.6.25-git14.orig/Documentation/DocBook/rapidio.tmpl
> > +++ linux-2.6.25-git14/Documentation/DocBook/rapidio.tmpl
> > @@ -133,7 +133,6 @@
> >  !Idrivers/rapidio/rio-sysfs.c
> >       </sect1>
> >       <sect1 id="PPC32_support"><title>PPC32 support</title>
> > -!Iarch/powerpc/kernel/rio.c
> >  !Earch/powerpc/sysdev/fsl_rio.c
> >  !Iarch/powerpc/sysdev/fsl_rio.c
> >       </sect1>
> 
> grumble.
> 
> This is a subset of rapidio-fix-docbook-references.patch, but I appear to
> be unable to interest anyone in merging/reviewing/accepting/anything-else
> that quite large set of patches.
> 
> Guys, those patches were sent six weeks ago and it now looks like they will
> miss 2.6.26.  This is pretty slack of us.  Help?

There's nothing there that can hurt.  (famous last words)

Just merge it.

---
~Randy
