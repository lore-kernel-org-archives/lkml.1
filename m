Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXF1Qdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXF1Qdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbXF1QdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:33:24 -0400
Received: from relay4.usu.ru ([194.226.235.39]:51762 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbXF1QdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:33:23 -0400
Message-ID: <4683E2CB.8090100@ums.usu.ru>
Date: Thu, 28 Jun 2007 22:33:15 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: man-pages-2.59 and man-pages-2.60 are released
References: <467F8FCF.4080009@gmx.net> <4683BC76.8070805@ums.usu.ru> <20070628161720.298550@gmx.net>
In-Reply-To: <20070628161720.298550@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> How about a link in /pub/linux/docs/manpages/ of the form 
> "LATEST-IS-m.xy"?  Rob Landley was wanting something like this,
> and I guess it would be easy for LFS to build a simple
> script that looks for that link and deduces "man-pages-m.xy" 
> from it.  (I've just now created such a link in the directory,
> as an example.)

We don't care about the latest version, so the link neither helps nor hurts 
us. What's needed is that the URL and the MD5 sum for a version in the book 
don't change, and that LFS developers have a reasonable time (say, two 
weeks) to react to version updates. We don't want every other SVN commit to 
the book source to be a version update of man-pages :)

E.g., currently, the book at 
http://www.linuxfromscratch.org/lfs/view/development/chapter03/packages.html 
says:

  Man-pages (2.56) - 1,764 KB:
     Download: 
http://www.kernel.org/pub/linux/docs/manpages/man-pages-2.56.tar.bz2
     MD5 sum: 4144874a924b0a8d1f67e19f70d13f08

The script parses this information out of the XML source of the book, 
downloads the package and installs it according to the instructions found 
elsewhere in the book.

The script (jhalfs) and the book can be downloaded from svn:

svn co svn://svn.linuxfromscratch.org/ALFS/jhalfs/trunk jhalfs
svn co svn://svn.linuxfromscratch.org/LFS/trunk/BOOK lfs

-- 
Alexander E. Patrakov
