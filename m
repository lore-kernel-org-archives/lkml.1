Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZF3Bbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZF3Bbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZF3Bbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:31:31 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:40310 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752452AbZF3Bbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:31:31 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: luFyKBsVM1lpPTPv2xB09DxZl3gMNPmP0rXVm7YWkUa5g1RDRE67BJm4qTvTfhZVTI_GE0fttvCrWFJDsLZ7l90PixxsJOayZ3mUKnf3Hl29Qsg6i4UP2Yg7gZgm7OlqKD6aQJX1FkP8w5bNN0mDe9GZj7rBoIVlHir0MLdFxdasIq4l9d4t9nAeX5g5O641sTMlfh29rD6nAgNLc9HtW7xAyglMBFgIpXOrTpp_BYqN_riv.v_4nKR2VSAhntoaM.I6isfuS7Ejvk..HxwQNdFzE4pEJHLAgZDd5djlRa5vunVu1vJAGLdoabRmvD2ytVlEN1OL9Ieh6SdHzsFfCDHurJ36p0RaHV0Us.oPBQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A496AE4.6090100@schaufler-ca.com>
Date: Mon, 29 Jun 2009 18:31:16 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, dank@qemfd.net, davem@davemloft.net,
       penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk
Subject: Re: + move-magic-numbers-into-magich.patch added to -mm tree
References: <200906291928.n5TJSKds005109@imap1.linux-foundation.org>
In-Reply-To: <200906291928.n5TJSKds005109@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The patch titled
>      Move magic numbers into magic.h
> has been added to the -mm tree.  Its filename is
>      move-magic-numbers-into-magich.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
>
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>
> ------------------------------------------------------
> Subject: Move magic numbers into magic.h
> From: Nick Black <dank@qemfd.net>
>
> Move various magic-number definitions into magic.h.
>
> Signed-off-by: Nick Black <dank@qemfd.net>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Thank you.
> ---
>
>  fs/devpts/inode.c          |    3 +--
>  include/linux/magic.h      |    4 ++++
>  net/socket.c               |    3 +--
>  security/smack/smack_lsm.c |    8 +-------
>  4 files changed, 7 insertions(+), 11 deletions(-)
>
> diff -puN fs/devpts/inode.c~move-magic-numbers-into-magich fs/devpts/inode.c
> --- a/fs/devpts/inode.c~move-magic-numbers-into-magich
> +++ a/fs/devpts/inode.c
> @@ -18,14 +18,13 @@
>  #include <linux/mount.h>
>  #include <linux/tty.h>
>  #include <linux/mutex.h>
> +#include <linux/magic.h>
>  #include <linux/idr.h>
>  #include <linux/devpts_fs.h>
>  #include <linux/parser.h>
>  #include <linux/fsnotify.h>
>  #include <linux/seq_file.h>
>  
> -#define DEVPTS_SUPER_MAGIC 0x1cd1
> -
>  #define DEVPTS_DEFAULT_MODE 0600
>  /*
>   * ptmx is a new node in /dev/pts and will be unused in legacy (single-
> diff -puN include/linux/magic.h~move-magic-numbers-into-magich include/linux/magic.h
> --- a/include/linux/magic.h~move-magic-numbers-into-magich
> +++ a/include/linux/magic.h
> @@ -53,4 +53,8 @@
>  #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
>  
>  #define STACK_END_MAGIC		0x57AC6E9D
> +
> +#define DEVPTS_SUPER_MAGIC	0x1cd1
> +#define SOCKFS_MAGIC		0x534F434B
> +
>  #endif /* __LINUX_MAGIC_H__ */
> diff -puN net/socket.c~move-magic-numbers-into-magich net/socket.c
> --- a/net/socket.c~move-magic-numbers-into-magich
> +++ a/net/socket.c
> @@ -86,6 +86,7 @@
>  #include <linux/audit.h>
>  #include <linux/wireless.h>
>  #include <linux/nsproxy.h>
> +#include <linux/magic.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -235,8 +236,6 @@ int move_addr_to_user(struct sockaddr *k
>  	return __put_user(klen, ulen);
>  }
>  
> -#define SOCKFS_MAGIC 0x534F434B
> -
>  static struct kmem_cache *sock_inode_cachep __read_mostly;
>  
>  static struct inode *sock_alloc_inode(struct super_block *sb)
> diff -puN security/smack/smack_lsm.c~move-magic-numbers-into-magich security/smack/smack_lsm.c
> --- a/security/smack/smack_lsm.c~move-magic-numbers-into-magich
> +++ a/security/smack/smack_lsm.c
> @@ -30,17 +30,11 @@
>  #include <net/netlabel.h>
>  #include <net/cipso_ipv4.h>
>  #include <linux/audit.h>
> +#include <linux/magic.h>
>  #include "smack.h"
>  
>  #define task_security(task)	(task_cred_xxx((task), security))
>  
> -/*
> - * I hope these are the hokeyist lines of code in the module. Casey.
> - */
> -#define DEVPTS_SUPER_MAGIC	0x1cd1
> -#define SOCKFS_MAGIC		0x534F434B
> -#define TMPFS_MAGIC		0x01021994
> -
>  /**
>   * smk_fetch - Fetch the smack label from a file.
>   * @ip: a pointer to the inode
> _
>
> Patches currently in -mm which might be from dank@qemfd.net are
>
> move-magic-numbers-into-magich.patch
>
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
