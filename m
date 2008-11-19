Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYKSTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYKSTNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYKSTNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:13:41 -0500
Received: from styx.suse.cz ([82.119.242.94]:54756 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753270AbYKSTNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:13:40 -0500
Date: Wed, 19 Nov 2008 20:13:38 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udf: implement mode and dmode mounting options
Message-ID: <20081119191338.GD29820@duck.suse.cz>
References: <20081116195129.GA5920@joi> <20081118162205.bc61e2b4.akpm@linux-foundation.org> <20081119151605.GA29820@duck.suse.cz> <20081119181427.GA29507@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119181427.GA29507@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-11-08 19:14:57, Marcin Slusarz wrote:
> On Wed, Nov 19, 2008 at 04:16:06PM +0100, Jan Kara wrote:
> > On Tue 18-11-08 16:22:05, Andrew Morton wrote:
> > > On Sun, 16 Nov 2008 20:52:19 +0100
> > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > "dmode" allows overriding permissions of directories and
> > > > "mode" allows overriding permissions of files.
> > > > 
> > > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > > Cc: Jan Kara <jack@suse.cz>
> > > > ---
> > > >  Documentation/filesystems/udf.txt |    2 ++
> > > >  fs/udf/inode.c                    |   11 +++++++++--
> > > >  fs/udf/super.c                    |   31 ++++++++++++++++++++++++++++++-
> > > >  fs/udf/udf_sb.h                   |    2 ++
> > > >  4 files changed, 43 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/Documentation/filesystems/udf.txt b/Documentation/filesystems/udf.txt
> > > > index fde829a..902b95d 100644
> > > > --- a/Documentation/filesystems/udf.txt
> > > > +++ b/Documentation/filesystems/udf.txt
> > > > @@ -24,6 +24,8 @@ The following mount options are supported:
> > > >  
> > > >  	gid=		Set the default group.
> > > >  	umask=		Set the default umask.
> > > > +	mode=		Set the default file permissions.
> > > > +	dmode=		Set the default directory permissions.
> > > 
> > > Can we give these the same names and usage as their fatfs equivalents?
> >   Yes, making these options dmask and fmask would be more consistent I
> > think. Martin?
> 
> You can't add permissions by umask/fmask/dmask. I have one DVD with top
> level dir permissions set to 0000 and there's no way to read it now (as
> an user) and adding mask options wouldn't change it.
> 
> I should mention in a changelog that the names and semantics of these
> options are copied from isofs.
> 
> I can create a second patch which adds mask options but I think modes are
> needed too. What do you think?
  Ah, ok. That makes sence (although such DVD's seem to be really broken).
I'll merge the patch.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
