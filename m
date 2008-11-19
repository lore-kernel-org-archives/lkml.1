Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYKSPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYKSPQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYKSPQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:16:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:46657 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753422AbYKSPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:16:09 -0500
Date: Wed, 19 Nov 2008 16:16:06 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: implement mode and dmode mounting options
Message-ID: <20081119151605.GA29820@duck.suse.cz>
References: <20081116195129.GA5920@joi> <20081118162205.bc61e2b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118162205.bc61e2b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-11-08 16:22:05, Andrew Morton wrote:
> On Sun, 16 Nov 2008 20:52:19 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > "dmode" allows overriding permissions of directories and
> > "mode" allows overriding permissions of files.
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Jan Kara <jack@suse.cz>
> > ---
> >  Documentation/filesystems/udf.txt |    2 ++
> >  fs/udf/inode.c                    |   11 +++++++++--
> >  fs/udf/super.c                    |   31 ++++++++++++++++++++++++++++++-
> >  fs/udf/udf_sb.h                   |    2 ++
> >  4 files changed, 43 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/udf.txt b/Documentation/filesystems/udf.txt
> > index fde829a..902b95d 100644
> > --- a/Documentation/filesystems/udf.txt
> > +++ b/Documentation/filesystems/udf.txt
> > @@ -24,6 +24,8 @@ The following mount options are supported:
> >  
> >  	gid=		Set the default group.
> >  	umask=		Set the default umask.
> > +	mode=		Set the default file permissions.
> > +	dmode=		Set the default directory permissions.
> 
> Can we give these the same names and usage as their fatfs equivalents?
  Yes, making these options dmask and fmask would be more consistent I
think. Martin?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
