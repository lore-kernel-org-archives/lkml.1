Return-Path: <linux-kernel-owner+w=401wt.eu-S1766006AbXHPWRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766006AbXHPWRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbXHPWQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:16:53 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53674 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758985AbXHPWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:16:53 -0400
Date: Fri, 17 Aug 2007 00:16:36 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [-mm patch] AFLAGS: fix the -g setting
Message-ID: <20070816221636.GA3786@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070814212329.GQ18945@stusta.de> <20070816140201.3ff0f582.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070816140201.3ff0f582.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 02:02:01PM -0700, Andrew Morton wrote:
> On Tue, 14 Aug 2007 23:23:29 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > It's -gdwarf-2, not -gdwarf2. With this fix it can actually work.
> 
> Andreas Schwab has said "The option is officially called -gdwarf-2, and
> -gdwarf2 is an alias for backward compatibility.".  So the code should be
> working OK now.

Both GNU gcc 3.2.3 downloaded from ftp.gnu.org and the
Debian GNU/Linux package of GNU gcc 4.2.1 disagree with Andreas:

$ gcc -O2 -gdwarf-2 test.c 
$ gcc -O2 -gdwarf2 test.c 
cc1: error: unrecognised debug output level "dwarf2"
$ gcc --version
gcc (GCC) 4.2.1 (Debian 4.2.1-0)
Copyright (C) 2007 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ /usr/local/DIR/gcc-3.2.3/bin/gcc -O2 -gdwarf2 test.c 
cc1: use -gdwarf -g2 for DWARF v1, level 2
cc1: use -gdwarf-2   for DWARF v2
$ 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

