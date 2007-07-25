Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbXGYVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbXGYVSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbXGYVSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:18:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44377 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751055AbXGYVSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:18:09 -0400
Date: Wed, 25 Jul 2007 23:17:41 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jason.wessel@windriver.com,
       amitkale@linsyssoft.com, lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: 2.6.23-rc1-mm1: git-kgdb breaks sh compilation
Message-ID: <20070725211741.GI3572@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
>  git-kgdb.patch
> 
>  git trees
>...

This causes the following compile error on sh:

<--  snip  -->

...
  CC      drivers/serial/sh-sci.o
drivers/serial/sh-sci.c: In function 'put_string':
drivers/serial/sh-sci.c:188: error: 'hexchars' undeclared (first use in this function)
drivers/serial/sh-sci.c:188: error: (Each undeclared identifier is reported only once
drivers/serial/sh-sci.c:188: error: for each function it appears in.)
make[3]: *** [drivers/serial/sh-sci.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

