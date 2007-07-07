Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXGGIDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXGGIDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 04:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXGGIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 04:03:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53315 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbXGGID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 04:03:28 -0400
Date: Sat, 7 Jul 2007 10:03:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jason.wessel@windriver.com,
       amitkale@linsyssoft.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: 2.6.22-rc6-mm1: git-kgdb breaks sh compilation
Message-ID: <20070707080358.GF3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-kgdb.patch
>...
>  git trees
>...

This tree adds to include/asm-sh/system.h code that already exists in 
the same file a few lines above resulting in compile errors.

Please remove the include/asm-sh/system.h part from the git tree.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

