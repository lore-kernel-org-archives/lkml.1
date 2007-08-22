Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXHVRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXHVRR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763163AbXHVRRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:17:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39386 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759842AbXHVRRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:17:48 -0400
Message-ID: <46CC6FB2.1010801@csn.ul.ie>
Date: Wed, 22 Aug 2007 18:17:38 +0100
From: Mel Gorman <mel@csn.ul.ie>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> - git-ixgbe.patch got dropped - git-net.patch destroyed it
> 
> - then git-net got dropped as it doesn't work
> 
> - the -mm import-to-git engine still isn't working
> 

>From elm3b6 on test.kernel.org, we get the following build error

08/22/07-07:01:07 building kernel - make bzImage
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86_64
  CC      arch/x86_64/kernel/asm-offsets.s
arch/x86_64/kernel/asm-offsets.c:1: error: -mpreferred-stack-boundary=3
is not between 4 and 12
make[1]: *** [arch/x86_64/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
08/22/07-07:01:08 Build the kernel. Failed rc = 2
08/22/07-07:01:08 build: Building kernel... Failed rc = 1
Failed and terminated the run
08/22/07-07:01:08 command complete: (1) rc=126 (TEST ABORT)
 Fatal error, aborting autorun

config file at: http://test.kernel.org/abat/107411/build/dotconfig
gcc version is 3.4.4

This does not occur when using a cross-compiler gcc 3.4.0

-- 
Mel Gorman
