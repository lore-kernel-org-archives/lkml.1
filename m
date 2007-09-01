Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbXIAOSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbXIAOSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 10:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXIAOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 10:18:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33813 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573AbXIAOSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 10:18:44 -0400
Date: Sat, 1 Sep 2007 16:18:45 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam@infradead.org>
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
       "Antonino A. Daplas" <adaplas@pol.net>
Subject: 2.6.23-rc4-mm1: geode fb compile error
Message-ID: <20070901141845.GG9260@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
> 
>  Fix drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch
>...

This patch doesn't fix 
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning.patch, together 
they break the compilation (2 - 1 - 1 = 0 < 1):

<--  snip  -->

...
  CC      drivers/video/geode/lxfb_core.o
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/drivers/video/geode/lxfb_core.c: In function ‘lxfb_setup’:
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/drivers/video/geode/lxfb_core.c:567: error: ‘opt’ undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/drivers/video/geode/lxfb_core.c:567: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/drivers/video/geode/lxfb_core.c:567: error: for each function it appears in.)
make[4]: *** [drivers/video/geode/lxfb_core.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

