Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYEWTwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYEWTwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbYEWTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:51:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56498 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271AbYEWTvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:51:43 -0400
Date: Fri, 23 May 2008 21:52:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       peter.oberparleiter@de.ibm.com, linux-kernel@vger.kernel.org,
       ltp-coverage@lists.sourceforge.net, oberparleiter@googlemail.com
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Message-ID: <20080523195222.GA366@uranus.ravnborg.org>
References: <48313E08.8070904@de.ibm.com> <20080522201724.cf4bd471.akpm@linux-foundation.org> <20080523171840.GD28257@cs181133002.pp.htv.fi> <20080523111707.89df9f67.akpm@linux-foundation.org> <20080523190950.GA32541@uranus.ravnborg.org> <19f34abd0805231242r32892322n6c0a25e06d93ff96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805231242r32892322n6c0a25e06d93ff96@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> Well I guess that's understandable with O=.
> >>
> >> But I find it rather nasty.  (I guess it'd be less nasty if I were to
> >> get off my butt and work out how to teach rxvt that "/" is a word
> >> separator).
> >>
> >> What do others think?
> >
> > That the gcov tool has a bug if it insist on using absolute paths.
> > And thus we should fix gcov and not workaround it in the kernel.
> 
> IIRC, there was also the slight problem that all uses of __FILE__
> (there are quite a few in the kernel) will also now be absolute and
> increase the size of the vmlinux image by quite a bit.
> 
> Yeah... http://lkml.org/lkml/2006/4/25/40
This is specific to O=.. build kernels.
I recall this is not an issue for the gcov patchset (if O=... is not used).
But I have not checked it.

	Sam
