Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXEPIJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXEPIJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbXEPIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:09:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39670 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbXEPIJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:09:18 -0400
Date: Wed, 16 May 2007 10:07:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 12/14] ext2 whiteout support
In-Reply-To: <20070514094427.GN4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705161006300.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094427.GN4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:14, Bharata B Rao wrote:
>
>--- a/fs/ext2/dir.c
>+++ b/fs/ext2/dir.c
>@@ -218,6 +218,7 @@ static unsigned char ext2_filetype_table
> 	[EXT2_FT_FIFO]		= DT_FIFO,
> 	[EXT2_FT_SOCK]		= DT_SOCK,
> 	[EXT2_FT_SYMLINK]	= DT_LNK,
>+	[EXT2_FT_WHT]		= DT_WHT,
> };
> 
> #define S_SHIFT 12
>@@ -1292,7 +1301,7 @@ static struct file_system_type ext2_fs_t
> 	.name		= "ext2",
> 	.get_sb		= ext2_get_sb,
> 	.kill_sb	= kill_block_super,
>-	.fs_flags	= FS_REQUIRES_DEV,
>+	.fs_flags	= FS_REQUIRES_DEV | FS_WHT,
> };
> 

Hum. It's always so short. Would it offend someone to make that
DT_WHITEOUT and/or FS_WHITEOUT?



	Jan
-- 
