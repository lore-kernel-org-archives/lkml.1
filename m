Return-Path: <linux-kernel-owner+w=401wt.eu-S1763846AbZDBV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763846AbZDBV7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZDBV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:59:28 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57331 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbZDBV71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:59:27 -0400
Date: Thu, 2 Apr 2009 17:59:26 -0400
To: Rob Landley <rob@landley.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090402215926.GD3795@csclub.uwaterloo.ca>
References: <200903120437.03837.rob@landley.net> <10f740e80904011323t219063b0ife4db1677ca0d22b@mail.gmail.com> <20090401225916.GZ3795@csclub.uwaterloo.ca> <200904012114.07183.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012114.07183.rob@landley.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 09:14:05PM -0500, Rob Landley wrote:
> uClibc's working for me just fine.  Either grab the most recent build scripts 
> from http://impactlinux.com/hg/firmware or grab the prebuilt binaries from 
> http://impactlinux.com/fwl/downloads/snapshots/ (which has cross compilers, 
> root filesystem tarballs, and system images bootable by qemu).
> 
> I haven't tested m68k yet because qemu doesn't support it (just coldfire), and 
> aranym hasn't got a serial console, but it did compile using the same build 
> scripts as all the other targets...

Well my uclibc issues using 0.9.30.1 are:

When using msh from busybox compiled with gcc 4.3.3 for m68k-uclinux with
-msep-data -mcpu=5271, only one pipe works.  Doing two pipes in a command
gives no output.

ie:
# echo 123 | cat
123

# echo 123 | cat | cat
<nothing here>

Also after each command I get the message "Illegal instruction", even
though the command always did its job.  So not sure if this is a bug
in msh of the current busybox release, or a bug in uclibc or gcc or
whichever.  Still searching.  I intend to try out sash soon to see if
it behaves any differently.

-- 
Len Sorensen
