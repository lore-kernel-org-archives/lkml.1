Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbXLBNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbXLBNs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbXLBNsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:48:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44091 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751643AbXLBNsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:48:50 -0500
Date: Sun, 2 Dec 2007 14:48:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-ID: <20071202134841.GI15974@stusta.de>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 05:43:39PM +0900, Tetsuo Handa wrote:
> 
> mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
>...

That's due to the fact that my patch to remove this unused export from 
slub was not yet applied...

Where is the modular in-kernel user?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

