Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZKLLYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZKLLYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZKLLYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:24:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:48706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZKLLYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:24:33 -0500
Date: Thu, 12 Nov 2009 12:24:37 +0100
From: Jan Kara <jack@suse.cz>
To: Livio Soares <livio@eecg.toronto.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3/jdb log_start_commit export symbol issue
Message-ID: <20091112112437.GF14528@duck.suse.cz>
References: <20091112003545.GB17247@eecg.toronto.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112003545.GB17247@eecg.toronto.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-11-09 19:35:45, Livio Soares wrote:
> 
>   Hi Jan and all,
> 
>   It seems like the below patch is necessary when trying to compile ext3 as
> a module. I don't  know if this is the correct fix  (that's up to you), but
> without ext3 does not link. The following commit caused the problem:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fe8bc91c4c30122b357d197117705cfd4fabaf28
  Thanks for notifying me, I've already merged the fix.

								Honza
> 
>   Cheers,
> 
> 		Livio
> 
> Signed-off-by: Livio Soares <livio@eecg.toronto.edu>
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 49d5cd6..4160afa 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -73,6 +73,7 @@ EXPORT_SYMBOL(journal_errno);
>  EXPORT_SYMBOL(journal_ack_err);
>  EXPORT_SYMBOL(journal_clear_err);
>  EXPORT_SYMBOL(log_wait_commit);
> +EXPORT_SYMBOL(log_start_commit);
>  EXPORT_SYMBOL(journal_start_commit);
>  EXPORT_SYMBOL(journal_force_commit_nested);
>  EXPORT_SYMBOL(journal_wipe);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
