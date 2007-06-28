Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXF1Xgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXF1Xgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbXF1Xgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:36:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43804 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760948AbXF1Xgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:36:36 -0400
Date: Fri, 29 Jun 2007 01:36:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc3-mm1: Xen compile error with X86_CMPXCHG=n
Message-ID: <20070628233659.GE6087@stusta.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070602135711.GB5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070602135711.GB5500@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 03:57:12PM +0200, Adrian Bunk wrote:
> I'm getting the following compile error in 2.6.22-rc3-mm1 with 
> CONFIG_X86_CMPXCHG=n (with -Werror-implicit-function-declaration - 
> otherwise it would be a link error):
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/xen/grant-table.o
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc3-mm1/drivers/xen/grant-table.c: In function ‘gnttab_end_foreign_access_ref’:
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc3-mm1/drivers/xen/grant-table.c:203: error: implicit declaration of function ‘sync_cmpxchg’
> make[3]: *** [drivers/xen/grant-table.o] Error 1
> 
> <--  snip  -->
> 
> Adding a dependency of XEN on X86_CMPXCHG should not be a problem and 
> not prevent any reasonable real-life usage.
> 
> But what worries me is that a seemingly architecture independent 
> driver uses a function only available in some configurations.

Still present as of 2.6.22-rc6-mm1.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

