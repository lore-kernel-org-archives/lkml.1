Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbZGBVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbZGBVpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZGBVpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:45:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60521 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbZGBVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:45:07 -0400
Date: Thu, 2 Jul 2009 23:45:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzj@lemote.com>
Subject: Re: [PATCH] [MIPS] Hibernation: only save pages in system ram
Message-ID: <20090702214503.GC1485@ucw.cz>
References: <1246373570-21090-1-git-send-email-wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246373570-21090-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> arch/mips/include/asm/page.h:
> 
> 	...
> 	#ifdef CONFIG_FLATMEM
> 
> 	#define pfn_valid(pfn)		((pfn) >= ARCH_PFN_OFFSET && (pfn) < max_mapnr)
> 
> 	#elif defined(CONFIG_SPARSEMEM)
> 
> 	/* pfn_valid is defined in linux/mmzone.h */
> 	...
> 
> we can rewrite pfn_valid(pfn) to fix this problem, but I really do not
> want to touch such a widely-used macro, so, I used another solution:

Well, fixing pfn_valid() is the right way to go. It makes mips behave
like other architectures. Please do that.

> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>

NAK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
