Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbXLKWX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbXLKWX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXLKWVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:21:55 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756080AbXLKWVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:21:42 -0500
Date: Tue, 11 Dec 2007 23:21:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Willy Tarreau <wtarreau@hera.kernel.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: restore missing clear_highpage
Message-ID: <20071211222143.GK14204@stusta.de>
References: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711281844370.25292@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 06:55:10PM +0000, Hugh Dickins wrote:
> tmpfs was misconverted to __GFP_ZERO in 2.6.11.  There's an unusual case in
> which shmem_getpage receives the page from its caller instead of allocating.
> We must cover this case by clear_highpage before SetPageUptodate, as before.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Desirable in 2.6.23-stable and 2.6.22-stable and 2.6.16-stable
>...

Thanks, applied to 2.6.16.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

