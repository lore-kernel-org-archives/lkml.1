Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXFLAHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXFLAHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXFLAHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:07:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60197 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751467AbXFLAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:07:07 -0400
Date: Tue, 12 Jun 2007 02:07:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, avi@qumranet.com
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-ID: <20070612000718.GS3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm1:
>...
>  git-kvm.patch
>...
>  git trees
>...

I'm getting the following compile error with CONFIG_X86_CMPXCHG64=n 
(with -Werror-implicit-function-declaration - otherwise it would be a 
link error):

<--  snip  -->

...
  CC [M]  drivers/kvm/mmu.o
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc4-mm2/drivers/kvm/mmu.c: In function ‘set_shadow_pte’:
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc4-mm2/drivers/kvm/mmu.c:199: error: implicit declaration of function ‘set_64bit’
make[3]: *** [drivers/kvm/mmu.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

