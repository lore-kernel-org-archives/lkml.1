Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYEWRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYEWRVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYEWRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:21:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40604 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbYEWRVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:21:08 -0400
Date: Fri, 23 May 2008 20:18:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Message-ID: <20080523171840.GD28257@cs181133002.pp.htv.fi>
References: <48313E08.8070904@de.ibm.com> <20080522201724.cf4bd471.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080522201724.cf4bd471.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 08:17:24PM -0700, Andrew Morton wrote:
> On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
> > From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> > 
> > Change all source and include paths to absolute form when
> > CONFIG_GCOV_PROFILE is enabled.
> > 
> > Example:
> > 
> >   gcc -Idir1 -c a.c -o a.o
> > 
> > will become
> > 
> >   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
> > 
> > Required by the gcov profiling infrastructure: when compiling with
> > option -fprofile-arcs, gcc stores file names inside object files.
> > Relative paths prevent the gcov tool from finding corresponding source
> > files.
> 
> I don't like this.  It converts the compiler error messages from
> relative paths to absolute paths which is rather obnoxious when
> all kernel developent is (or should be) base-directory-agnostic.

The compiler error messages are already absolute paths when using O=
(see e.g. all error messages sent by me in recent years).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

