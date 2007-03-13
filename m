Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbXCMFC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbXCMFC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXCMFC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:02:26 -0400
Received: from xenotime.net ([66.160.160.81]:52235 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753112AbXCMFCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:02:25 -0400
Date: Mon, 12 Mar 2007 22:02:18 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: sukadev@us.ibm.com
cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix some coding-style errors in autofs
In-Reply-To: <20070313045023.GB8993@us.ibm.com>
Message-ID: <Pine.LNX.4.58.0703122156370.22327@shark.he.net>
References: <20070313045023.GB8993@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 sukadev@us.ibm.com wrote:

> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Subject: [PATCH 1/2] Fix some coding-style errors in autofs
>
> Fix coding style errors (extra spaces, long lines) in autofs
> and autofs4 files being modified for container/pidspace issues.
>
> ---
>  fs/autofs/inode.c  |   29 +++++++++++--------
>  fs/autofs/root.c   |   77 ++++++++++++++++++++++++++---------------------------
>  fs/autofs4/inode.c |   16 ++++-------
>  fs/autofs4/root.c  |   18 ++++++------
>  4 files changed, 70 insertions(+), 70 deletions(-)
>
> Index: lx26-20-mm2c/fs/autofs/inode.c
> ===================================================================
> --- lx26-20-mm2c.orig/fs/autofs/inode.c	2007-02-28 14:48:35.000000000 -0800
> +++ lx26-20-mm2c/fs/autofs/inode.c	2007-02-28 15:47:09.000000000 -0800
> @@ -34,12 +34,12 @@ void autofs_kill_sb(struct super_block *
>
>  	autofs_hash_nuke(sbi);
> -	for ( n = 0 ; n < AUTOFS_MAX_SYMLINKS ; n++ ) {
> -		if ( test_bit(n, sbi->symlink_bitmap) )
> +	for (n = 0 ; n < AUTOFS_MAX_SYMLINKS ; n++) {
> +		if (test_bit(n, sbi->symlink_bitmap))
>  			kfree(sbi->symlink[n].data);
>  	}

Please do a complete job on the 'for' line by eliminating the
space before each semi-colon.

-- 
~Randy
