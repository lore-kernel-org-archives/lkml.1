Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYBFQzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYBFQzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYBFQy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:54:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:42133 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbYBFQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:54:58 -0500
Date: Wed, 6 Feb 2008 17:54:57 +0100
From: Jan Kara <jack@suse.cz>
To: Andreas Schwab <schwab@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add explanation of I_DIRTY_DATASYNC bit
Message-ID: <20080206165457.GC3475@duck.suse.cz>
References: <20080206162920.GB3475@duck.suse.cz> <jeejbqt544.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jeejbqt544.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 06-02-08 17:35:39, Andreas Schwab wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > Add explanation of I_DIRTY_DATASYNC bit.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 56bd421..475125e 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -1280,7 +1280,10 @@ struct super_operations {
> >   * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
> >   *
> >   * I_DIRTY_SYNC		Inode itself is dirty.
> > - * I_DIRTY_DATASYNC	Data-related inode changes pending
> > + * I_DIRTY_DATASYNC	Data-related inode changes pending. We keep track of
> > + *		`	these changes separately from I_DIRTY_SYNC so that we
>                 ^
> 
> Looks like a typo.
  Oh, OK. Thanks for spotting this. Just next to tab ;). I'll resend a
patch without the typo.

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
