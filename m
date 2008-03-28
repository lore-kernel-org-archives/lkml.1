Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYC1UUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYC1UUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYC1UUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:20:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4701 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753938AbYC1UUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:20:37 -0400
Date: Fri, 28 Mar 2008 21:20:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080328202032.GB3974@ucw.cz>
References: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206578760-9050-2-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-26 20:45:55, Bob Copeland wrote:
> Add basic superblock and inode handling routines for OMFS
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  fs/omfs/inode.c |  496 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 496 insertions(+), 0 deletions(-)
>  create mode 100644 fs/omfs/inode.c
> 
> diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> new file mode 100644
> index 0000000..b1cad5e
> --- /dev/null
> +++ b/fs/omfs/inode.c
> @@ -0,0 +1,496 @@
> +/*
> + * Optimized MPEG FS - inode and super operations.
> + * Copyright (C) 2006 Bob Copeland <me@bobcopeland.com>
> + */

If you have copyright, add GPL notice, too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
