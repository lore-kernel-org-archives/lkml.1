Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbYIQObZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbYIQObZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYIQObP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:31:15 -0400
Received: from lazybastard.de ([212.112.238.170]:56669 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYIQObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:31:14 -0400
Date: Wed, 17 Sep 2008 16:31:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Koji Sato <sato.koji@lab.ntt.co.jp>
Subject: Re: [PATCH 02/27] nilfs2: disk format and userland interface
Message-ID: <20080917143103.GC8750@logfs.org>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> <1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 September 2008 04:07:59 +0900, Ryusuke Konishi wrote:
>
> +struct nilfs_inode {
> +	__le64	i_blocks;
> +	__le64	i_size;
> +	__le64	i_ctime;
> +	__le64	i_mtime;
> +	__le64	i_dtime;
> +	__le32	i_uid;
> +	__le32	i_gid;
> +	__le16	i_mode;
> +	__le16	i_links_count;
> +	__le32	i_flags;
> +	__le64	i_bmap[NILFS_INODE_BMAP_SIZE];
> +#define i_device_code	i_bmap[0]
> +	__le64	i_xattr;
> +	__le32	i_generation;
> +	__le32	i_pad;
> +};

No atime.  Seems familiar. :)

Did you test the filesystem on big endian systems?  It is relatively
easy to miss bugs if conversion isn't actually necessary.

Jörn

-- 
When people work hard for you for a pat on the back, you've got
to give them that pat.
-- Robert Heinlein
