Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYKCOPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYKCOPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYKCOOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:14:53 -0500
Received: from genesysrack.ru ([195.178.208.66]:48506 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYKCOOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:14:52 -0500
Date: Mon, 3 Nov 2008 17:14:50 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: [PATCH V2 00/16] Squashfs: compressed read-only filesystem
Message-ID: <20081103141450.GC27263@ioremap.net>
References: <E1Kv0C3-0006GU-ES@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kv0C3-0006GU-ES@dylan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Oct 29, 2008 at 01:49:55AM +0000, Phillip Lougher (phillip@lougher.demon.co.uk) wrote:
> Summary of changes in patch respin:
> 
> 1. Functions changed to return 0 on success and -ESOMETHING on error
> 2. Header files moved from include/linux to fs/squashfs
> 3. Variables changed to use sb and inode
> 4. Number of squashfs_read_metadata() parameters reduced
> 5. Xattr placeholder code tweaked
> 6. TRACE and ERROR macros fixed to use pr_debug and pr_warning
> 7. Some obsolete macros in squashfs_fs.h removed
> 8. A number of gotos to return statements replaced with direct returns
> 9. Sparse with endian checking (make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__")
>    errors fixed
> 10. get_dir_index_using_name() misaligned access fixed
> 11. Fix a couple of printk warnings on PPC64
> 12. Shorten a number of variable names

Looks very good.

As a generic comment of the style: imho u64 is more appropriate than
long long, at least it is less keys to press when typing :)

-- 
	Evgeniy Polyakov
