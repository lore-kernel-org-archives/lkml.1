Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYCZWHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYCZWHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYCZWHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:07:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYCZWHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:07:21 -0400
Date: Wed, 26 Mar 2008 15:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] vfs: mountinfo (v3)
Message-Id: <20080326150655.43e9acd7.akpm@linux-foundation.org>
In-Reply-To: <20080326211131.705321084@szeredi.hu>
References: <20080326211131.705321084@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 22:11:31 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Here's an updated mountinfo patch with the following changes relative
> to the last submission (the one currently in -mm):
> 
>  - in __d_path() don't add extra parameter for checking unreachable path
>  - reduce proliferation of #ifdef CONFIG_PROC_FS into dcache.c and seq_file.c
>  - make peer group ID allocation a separate pass from setting mount shared
>  - change order and format of fields in /proc/<pid>/mountinfo
>  - remove dubious cleanups
>  - consolidate locking: don't use vfsmount_lock where namespace_sem suffices
>  - patch history was getting tangled up, merge and resplit into logical chunks
> 
> This series is also available here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git mountinfo

I coudn't get that to work, perhaps due to lack of gittiness.

> I guess the simplest for all involved parties would be if this went
> into Al's tree (if it looks OK) and then Andrew can suck that tree (*)
> containing all sort of goodies into -mm.
> 
> (*) git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git vfs-2.6.25

I recently added that tree to the -mm lineup as git-vfs.patch, and it's in
linux-next.

This patch series applied happily on top of git-vfs (and 887 other patches ;))

