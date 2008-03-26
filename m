Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYCZVXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYCZVXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbYCZVWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:22:08 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58476 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbYCZVV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:21:59 -0400
Message-Id: <20080326211131.705321084@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 26 Mar 2008 22:11:31 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/7] vfs: mountinfo (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated mountinfo patch with the following changes relative
to the last submission (the one currently in -mm):

 - in __d_path() don't add extra parameter for checking unreachable path
 - reduce proliferation of #ifdef CONFIG_PROC_FS into dcache.c and seq_file.c
 - make peer group ID allocation a separate pass from setting mount shared
 - change order and format of fields in /proc/<pid>/mountinfo
 - remove dubious cleanups
 - consolidate locking: don't use vfsmount_lock where namespace_sem suffices
 - patch history was getting tangled up, merge and resplit into logical chunks

This series is also available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git mountinfo

I guess the simplest for all involved parties would be if this went
into Al's tree (if it looks OK) and then Andrew can suck that tree (*)
containing all sort of goodies into -mm.

(*) git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git vfs-2.6.25

Thanks,
Miklos

--
