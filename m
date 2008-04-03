Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYDCSU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYDCSU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYDCSUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:20:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41846 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYDCSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:20:08 -0400
Date: Thu, 3 Apr 2008 14:20:01 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       hch@infradead.org
Subject: Re: fs_stack/eCryptfs: remove 3rd arg of copy_attr_all, add
	locking to copy_inode_size
Message-ID: <20080403182001.GB30189@josefsipek.net>
References: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804030149.m331nBCv005555@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:49:11PM -0400, Erez Zadok wrote:
...
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> +	spin_lock(&dst->i_lock);
> +#endif

I think you need to check CONFIG_PREEMPT as well.

Josef 'Jeff' Sipek.

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw
