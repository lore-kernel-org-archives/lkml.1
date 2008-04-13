Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYDMILD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYDMILD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYDMIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:10:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYDMIKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:10:46 -0400
Date: Sun, 13 Apr 2008 04:10:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 7/7] omfs: update kbuild to include OMFS
Message-ID: <20080413081045.GH9622@infradead.org>
References: <1208041121-26787-8-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208041121-26787-8-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- /dev/null
> +++ b/fs/omfs/Makefile
> @@ -0,0 +1,7 @@
> +#
> +# Makefile for the Linux omfs filesystem routines.
> +#
> +
> +obj-$(CONFIG_OMFS_FS) += omfs.o
> +
> +omfs-objs := bitmap.o checksum.o dir.o file.o inode.o


No need to comment a trivial makefile.  Also please use omfs-y +=
instead of omfs-objs :=
