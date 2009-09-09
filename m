Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZIIVZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZIIVZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZIIVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:24:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369AbZIIVY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:24:57 -0400
Date: Wed, 9 Sep 2009 14:24:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, matthew@wil.cx,
       agruen@suse.de, viro@zeniv.linux.org.uk, hch@lst.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: no "(unreachable)" prefix for SYSVIPC maps in
 /proc/PID/maps
Message-Id: <20090909142403.c3b35d4d.akpm@linux-foundation.org>
In-Reply-To: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu>
References: <E1Mkg2P-0000mi-H3@pomaz-ex.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Sep 2009 17:21:49 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Another fix for vfs-fix-d_path-for-unreachable-paths.patch in -mm.
> 

Now I'm confused.

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> The patch
> 
>   "vfs: fix d_path() for unreachable paths"
> 
> generally changed d_path() to report unreachable paths with a special
> prefix.  This has an effect on /proc/${PID}/maps as well for memory
> maps set up with shmem_file_setup() or hugetlb_file_setup().  These
> functions set up unlinked files under a kernel-private vfsmount.
> Since this vfsmount is unreachable from userspace, these maps will be
> reported with the "(unreachable)" prefix.
> 
> This is undesirable, because it changes the kernel ABI and might break
> applications for no good reason.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

These three patches are fixes against
vfs-fix-d_path-for-unreachable-paths.patch?  The description for
seq_file-return-a-negative-error-code-when-seq_path_root-fails.patch
led me to believe that vfs-fix-d_path-for-unreachable-paths.patch was
to be dropped.

argh.
