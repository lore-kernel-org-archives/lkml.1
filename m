Return-Path: <linux-kernel-owner+w=401wt.eu-S1763845AbXF1QRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763845AbXF1QRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXF1QRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:17:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:36378 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757582AbXF1QRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:17:22 -0400
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 28 Jun 2007 18:17:20 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
In-Reply-To: <4683BC76.8070805@ums.usu.ru>
Message-ID: <20070628161720.298550@gmx.net>
MIME-Version: 1.0
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/gCNEnL57gRGqQgPmtmUXB7eIoh6s+xJm3JSMqEm
 xPxGAsBCsGs7klaLQ5+xl7ybK1w+m0gMD+TQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: J+mwcv08TXsuXNX7GmU5RWVCRzdyMgPr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

> > I just released man-pages-2.59 and man-pages-2.60.
> > 
> > These releases are now available for download at:
> > 
> >     http://www.kernel.org/pub/linux/docs/manpages

Yes, just this morning I decided to tidy away some of the old
tarballs into a newly created "old" directory.
 
> There is one little problem with this: there is no stable URL for a given 
> version. 

Well, there never really was.  To date, most old tarballs have
had only a limited life on kernel.org.

> This hurts, e.g., automated Linux From Scratch rebuilds (the 
> official script grabs the URL from the book, but it becomes invalid too
> soon).
>
> Could you please, in order to avoid this, do what SAMBA team does: place 
> into http://www.kernel.org/pub/linux/docs/manpages/Old not only old 
> versions, but also the current version? This way, LFS will be sure that
> the  2.60 version is always available as 

As noted above old versions never were "always available" on
kernel.org...

> http://www.kernel.org/pub/linux/docs/manpages/Old/man-pages-2.60.tar.bz2 
> (even if it is in fact the latest version).

How about a link in /pub/linux/docs/manpages/ of the form 
"LATEST-IS-m.xy"?  Rob Landley was wanting something like this,
and I guess it would be easy for LFS to build a simple
script that looks for that link and deduces "man-pages-m.xy" 
from it.  (I've just now created such a link in the directory,
as an example.)

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.

