Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZAEN1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZAEN1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZAEN1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:27:30 -0500
Received: from netgear.net.ru ([195.178.208.66]:53014 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbZAEN12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:27:28 -0500
Date: Mon, 5 Jan 2009 16:27:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: Re: [PATCH V3 00/17] Squashfs: compressed read-only filesystem
Message-ID: <20090105132725.GC14147@ioremap.net>
References: <E1LJnJn-0002Kx-Dd@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LJnJn-0002Kx-Dd@dylan.lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phillip.

On Mon, Jan 05, 2009 at 11:08:23AM +0000, Phillip Lougher (phillip@lougher.demon.co.uk) wrote:
> This a second respin of the Squashfs patches incorporating the review comments
> received.  Thanks to everyone who have sent comments.
> 
> Summary of changes in patch respin:
> 
> 1. Vmalloc removed, smaller PAGE_CACHE_SIZE buffers are now allocated
> 2. Renamed some global functions, prefixing with squashfs_
> 3. brelse changed to put_bh
> 4. cache->lock coverage extended in squashfs_put_cache() and
>    squashfs_cache_get()
> 5. New squashfs.txt file in Documentation/filesystems
> 6. Changed 'long long' usage to u64 for variables referring to 64-bit
>    filesystem locations
> 7. SQUASHFS_I() renamed to squashfs_i()
> 8. Renamed locked variable to refcount to clarify usage
> 9. Renamed waiting variable to num_waiters, making it clear it is a count
>    rather than a boolean
> 10. Made pending and error fields int rather than char


Looks good.
You can also update the year in the copyright string in the files :)

-- 
	Evgeniy Polyakov
