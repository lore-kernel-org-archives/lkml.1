Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXLWMRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXLWMRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXLWMQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:16:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXLWMQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:16:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc6-mm1
Date: Sun, 23 Dec 2007 13:35:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231335.58939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> 
> - This kernel doesn't work on i386!
> 
>   It oopses late in boot due to an unrevertable change (e3c1b141) in git-x86
>   which I stared at for a while then I ran out of time and gave up.
> 
>   I would have just abandoned this release until it was fixed but I'll be
>   largely offline for ten days starting tomorrow.
> 
>   The culprits have been notified and hopefully we'll have a patch for
>   hot-fixes/ tomorrow.
> 
>   x86_64 and powerpc work OK though.

Well it doesn't build on x86-64 for me:

  CHK     include/linux/compile.h
  CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
Assembler messages:
Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2

I will post the .config if anyone is interested.

Thanks,
Rafael
