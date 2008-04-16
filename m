Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYDPD6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYDPD6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYDPD6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:58:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbYDPD6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EHSDmOqPYJo2PgjCQgqFJVNuqNTZAakRKg+gemhbmm6mot1hap/I4vckPKGeeR2pE7dZV/P+XP1DAMXRTXDr0Z5bEOydlDr8Mq9Uexb/uP2yfZumvZ3jnK2xSm+dhXQr4XV+I5yknOW2gtmnOsNwpk0ODalCeHNPeqq0g7xpKm0=
Message-ID: <524f69650804152058v4b12cfc2xc3c60d42c3e64b32@mail.gmail.com>
Date: Tue, 15 Apr 2008 22:58:06 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Fw: [2.6 patch] make cifs_dfs_automount_list static
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
In-Reply-To: <OF56FD7422.17D776A1-ON8725742B.006981FF-8625742B.00699B35@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OF56FD7422.17D776A1-ON8725742B.006981FF-8625742B.00699B35@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git tree

> Adrian Bunk <bunk@kernel.org>
> 04/14/2008 01:13 PM
>
> To
> Igor Mammedov <niallain@gmail.com>, Steven French/Austin/IBM@IBMUS
> cc
> linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
> Subject
> [2.6 patch] make cifs_dfs_automount_list static
>
>
> This patch makes the needlessly global cifs_dfs_automount_list static.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
> This patch has been sent on:
> - 31 Mar 2008
>
>  fs/cifs/cifs_dfs_ref.c |    2 +-
>  fs/cifs/cifsfs.h       |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> 7bd42d48fcdcda24f48c025ca4bfd31b2bf77d46 diff --git
> a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index a1a95b0..33719df 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -23,7 +23,7 @@
>  #include "dns_resolve.h"
>  #include "cifs_debug.h"
>
> -LIST_HEAD(cifs_dfs_automount_list);
> +static LIST_HEAD(cifs_dfs_automount_list);
>
>  /*
>  * DFS functions
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 6897830..dbaefc3 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -62,7 +62,6 @@ extern int cifs_setattr(struct dentry *, struct iattr
> *);
>
>  extern const struct inode_operations cifs_file_inode_ops;
>  extern const struct inode_operations cifs_symlink_inode_ops;
> -extern struct list_head cifs_dfs_automount_list;
>  extern struct inode_operations cifs_dfs_referral_inode_operations;
>
>

-- 
Thanks,

Steve
