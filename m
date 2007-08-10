Return-Path: <linux-kernel-owner+w=401wt.eu-S936334AbXHJR2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936334AbXHJR2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXHJR2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:28:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55461 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752792AbXHJR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:28:46 -0400
Date: Fri, 10 Aug 2007 19:28:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Aurelien Jarno <aurelien@aurel32.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810172832.GA20659@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070810092334.GA15285@hall.aurel32.net> <26090.1186764049@turing-police.cc.vt.edu> <20070810165906.GI18938@stusta.de> <28698.1186766481@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <28698.1186766481@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 01:21:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 10 Aug 2007 18:59:06 +0200, Adrian Bunk said:
> 
> > It must be included on *all* architectures, and the architectures where 
> > asm/page.h wasn't by chance already included indirectly included by some 
> > other header don't compile.
> 
> Wow. So it happened to work by chance on *most* architectures (or at
> least enough so Andrew shipped it)?  I wasn't expecting "MIPS was the
> first one to correctly barf because the header wasn't included"... :)

According to [1] it broke compilation on the following architectures:
- arm
- frv
- mips
- parisc
- v850
- xtensa

cu
Adrian

[1] http://l4x.org/k

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

