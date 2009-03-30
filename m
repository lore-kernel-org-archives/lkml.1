Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZC3Sun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZC3Sun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZC3Suc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:50:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40949 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZC3Sub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:50:31 -0400
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 32/35 code-cleanup] reiserfs: rename p_s_inode to inode
From: Andi Kleen <andi@firstfloor.org>
References: <20090330180215.951354436@suse.com>
	<20090330181013.465420330@suse.com>
Date: Mon, 30 Mar 2009 20:50:27 +0200
In-Reply-To: <20090330181013.465420330@suse.com> (Jeff Mahoney's message of "Mon, 30 Mar 2009 14:02:47 -0400")
Message-ID: <87tz5alua4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> writes:
>
> --- a/fs/reiserfs/file.c
> +++ b/fs/reiserfs/file.c
> @@ -137,17 +137,17 @@ static void reiserfs_vfs_truncate_file(s
>  static int reiserfs_sync_file(struct file *p_s_filp,
>  			      struct dentry *p_s_dentry, int datasync)
>  {
> -	struct inode *p_s_inode = p_s_dentry->d_inode;
> +	struct inode *inode = p_s_dentry->d_inode;
>  	int n_err;
>  	int barrier_done;

Didn't you miss one here?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
