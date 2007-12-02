Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbXLBQQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbXLBQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXLBQQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:16:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36944 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305AbXLBQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:16:21 -0500
Date: Sun, 2 Dec 2007 17:16:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.24-rc3-git6] SLUB's ksize() fails for size > 2048.
Message-ID: <20071202161613.GM15974@stusta.de>
References: <200712021939.HHH18792.FLQSOOtFOFJVHM@I-love.SAKURA.ne.jp> <4752D59B.1020907@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4752D59B.1020907@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 10:56:11AM -0500, Mark Lord wrote:
> Tetsuo Handa wrote:
>...
>> kernel BUG at mm/slub.c:2562!
>...
> Is "p" NULL ?   Where'd your printk() output go to?

Check the source, that's not the BUG_ON(!object), it's the 
BUG_ON(!page).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

