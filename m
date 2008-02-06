Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbYBFQfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbYBFQfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBFQfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:35:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:50783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYBFQfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:35:41 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add explanation of I_DIRTY_DATASYNC bit
References: <20080206162920.GB3475@duck.suse.cz>
X-Yow: I have a TINY BOWL in my HEAD
Date: Wed, 06 Feb 2008 17:35:39 +0100
In-Reply-To: <20080206162920.GB3475@duck.suse.cz> (Jan Kara's message of "Wed\,
	6 Feb 2008 17\:29\:20 +0100")
Message-ID: <jeejbqt544.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> Add explanation of I_DIRTY_DATASYNC bit.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 56bd421..475125e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1280,7 +1280,10 @@ struct super_operations {
>   * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
>   *
>   * I_DIRTY_SYNC		Inode itself is dirty.
> - * I_DIRTY_DATASYNC	Data-related inode changes pending
> + * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
> + *		`	these changes separately from I_DIRTY_SYNC so that we
                ^

Looks like a typo.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
