Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYDHIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYDHIdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYDHId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:33:29 -0400
Received: from lazybastard.de ([212.112.238.170]:55637 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYDHId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:33:28 -0400
Date: Tue, 8 Apr 2008 10:33:17 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 1/15] Makefiles and Kconfig
Message-ID: <20080408083316.GA31262@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833001@logfs.org> <200804080230.17426.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804080230.17426.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 April 2008 02:30:16 +0200, Arnd Bergmann wrote:
> On Tuesday 01 April 2008, joern@logfs.org wrote:
> > --- linux-2.6.24logfs/fs/Kconfig~logfs	2008-03-24 12:39:10.190939342 +0100
> > +++ linux-2.6.24logfs/fs/Kconfig	2008-04-01 19:48:18.517351063 +0200
> > @@ -1385,6 +1385,23 @@ config JFFS2_CMODE_FAVOURLZO
> >  
> >  endchoice
> >  
> > +config LOGFS
> > +	bool "Log Filesystem (EXPERIMENTAL)"
> 
> Is it really still the "Log Filesystem"? By now, I had the impression
> that "logfs" is a name by itself, so it should be called the
> "Logfs file system", and "config LOGFS_FS" respectively, like
> JFFS2_FS, REISERFS_FS, AUTOFS_FS, UDF_FS etc.

"Logfs file system" might make sense.  LOGFS_FS is something I would
rather avoid.  For some reason my brain reacts strongly to repetition,
redundancy and superfluous information.

> You shouldn't add the Makefile and Kconfig before adding the actual
> files, or you could cause git-bisect problems.

:)

I keep hearing that and I also continue to forget it.  It shouldn't
matter either way, because it simply makes no sense to merge 15 seperate
patches file-by-file for something that is functionally one change.  The
split is all about review and has nothing to do with merging.

But if I finally remembered it, at least these comments would cease.
I'll try.

Jörn

-- 
Beware of bugs in the above code; I have only proved it correct, but
not tried it.
-- Donald Knuth
