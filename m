Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYAYOeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYAYOeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYAYOeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:34:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41657 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYAYOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:34:15 -0500
Date: Fri, 25 Jan 2008 15:34:14 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@MIT.EDU>
Subject: Re: [patch 11/26] mount options: fix ext2
Message-ID: <20080125143414.GA28856@atrey.karlin.mff.cuni.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193430.818971789@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193430.818971789@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add noreservation option to /proc/mounts for ext2 filesystems.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/ext2/super.c
> ===================================================================
> --- linux.orig/fs/ext2/super.c	2008-01-17 19:00:55.000000000 +0100
> +++ linux/fs/ext2/super.c	2008-01-23 21:38:08.000000000 +0100
> @@ -285,6 +285,9 @@ static int ext2_show_options(struct seq_
>  		seq_puts(seq, ",xip");
>  #endif
>  
> +	if (!test_opt(sb, RESERVATION))
> +		seq_puts(seq, ",noreservation");
> +
>  	return 0;
>  }
  Looks fine. Acked-by: Jan Kara <jack@suse.cz>

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
