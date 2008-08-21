Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYHUI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYHUI4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYHUI4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:56:38 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:61803 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYHUI4h (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:56:37 -0400
Message-ID: <48AD2D7F.9070109@de.ibm.com>
Date: Thu, 21 Aug 2008 10:55:27 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
References: <48AD0101.4020505@gmail.com>
In-Reply-To: <48AD0101.4020505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> diff --git a/fs/axfs/axfs_super.c b/fs/axfs/axfs_super.c
> new file mode 100644
> index 0000000..5efab38
> --- /dev/null
> +++ b/fs/axfs/axfs_super.c
> +/***************** functions in other axfs files ***************************/
> +int axfs_get_sb_bdev(struct file_system_type *, int, const char *,
> +		     struct axfs_super *, struct vfsmount *, int *);
> +void axfs_kill_block_super(struct super_block *);
> +int axfs_copy_block(struct super_block *, void *, u64, u64);
> +int axfs_is_dev_bdev(char *);
> +int axfs_map_mtd(struct super_block *);
> +void axfs_unmap_mtd(struct super_block *);
> +int axfs_copy_mtd(struct super_block *, void *, u64, u64);
> +int axfs_get_sb_mtd(struct file_system_type *, int, const char *,
> +		    struct axfs_super *, struct vfsmount *, int *);
> +int axfs_is_dev_mtd(char *, int *);
> +void axfs_kill_mtd_super(struct super_block *);
> +struct inode *axfs_create_vfs_inode(struct super_block *, int);
> +int axfs_get_uml_address(char *, unsigned long *, unsigned long *);
> +int axfs_init_profiling(struct axfs_super *);
> +int axfs_shutdown_profiling(struct axfs_super *);
> +void axfs_profiling_add(struct axfs_super *, unsigned long, unsigned int);
> +struct inode *axfs_create_vfs_inode(struct super_block *, int);
Please put these definitions into a header file.

