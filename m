Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYJLOYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYJLOYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 10:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYJLOYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 10:24:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52178 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYJLOX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 10:23:59 -0400
Date: Sun, 12 Oct 2008 10:13:03 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] provide generic_block_fiemap() only with BLOCK=y
Message-ID: <20081012141303.GA31915@unused.rdu.redhat.com>
References: <20081012041519.GC31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012041519.GC31153@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 07:15:19AM +0300, Adrian Bunk wrote:
> This patch fixes the following compile error with CONFIG_BLOCK=n caused 
> by commit 68c9d702bb72f367f3b148963ec6cf5e07ff7f65
> (generic block based fiemap implementation):
> 
> <--  snip  -->
> 
> ...
>   CC      fs/ioctl.o
> fs/ioctl.c: In function 'generic_block_fiemap':
> fs/ioctl.c:249: error: storage size of 'tmp' isn't known
> fs/ioctl.c:272: error: invalid application of 'sizeof' to incomplete type 'struct buffer_head' 
> fs/ioctl.c:280: error: implicit declaration of function 'buffer_mapped'
> fs/ioctl.c:249: warning: unused variable 'tmp'
> make[2]: *** [fs/ioctl.o] Error 1
> 
> <--  snip  -->
> 
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>

Acked-by: Josef Bacik <jbacik@redhat.com>

Thanks,

Josef 
