Return-Path: <linux-kernel-owner+w=401wt.eu-S936679AbXHHRJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679AbXHHRJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764348AbXHHRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:08:57 -0400
Received: from smtp.nokia.com ([131.228.20.172]:31942 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763319AbXHHRIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:08:55 -0400
Subject: Re: [Patch 05/18] fs/logfs/dir.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: akpm@osdl.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070808161626.GG15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
	 <20070808161626.GG15319@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 08 Aug 2007 20:07:34 +0300
Message-Id: <1186592854.19606.49.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 08 Aug 2007 17:07:34.0260 (UTC) FILETIME=[9CF4BB40:01C7D9DE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 18:16 +0200, Jörn Engel wrote:
> +static inline void logfs_inc_count(struct inode *inode)
> +{
> +	inode->i_nlink++;
> +	mark_inode_dirty_sync(inode);
> +}
> +
> +static inline void logfs_dec_count(struct inode *inode)
> +{
> +	inode->i_nlink--;
> +	mark_inode_dirty_sync(inode);
> +}
include/linux/fs.h: inode_inc_link_count() inode_dec_link_count() do
this. Although not sure they exist in the old kernel your patches are
against.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

