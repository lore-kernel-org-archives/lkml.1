Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYAILM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYAILM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYAILMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:12:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38316 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753432AbYAILMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:12:36 -0500
Date: Wed, 9 Jan 2008 12:12:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: nigel@nigel.suspend2.net, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
Message-ID: <20080109111242.GB9735@elf.ucw.cz>
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080108214625.GE5050@ucw.cz> <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu> <47840DAC.5000108@nigel.suspend2.net> <E1JCWax-0005Ck-Kg@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JCWax-0005Ck-Kg@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-09 09:47:31, Miklos Szeredi wrote:
> > >> On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
> > >>> From: Miklos Szeredi <mszeredi@suse.cz>
> > >>>
> > >>> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> > >>>
> > >>> FUSE was designed from the beginning to be safe for unprivileged users.  This
> > >>> has also been verified in practice over many years.  In addition unprivileged
> > >> Eh? So 'kill -9 no longer works' and 'suspend no longer works' is not
> > >> considered important enough to even mention?
> > > 
> > > No.  Because in practice they don't seem to matter.  Also because
> > > there's no way in which fuse could be done differently to address
> > > these issues.
> > 
> > Could you clarify, please? I hope I'm getting the wrong end of the stick
> > - it sounds to me like you and Pavel are saying that this patch breaks
> > suspending to ram (and hibernating?) but you want to push it anyway
> > because you haven't been able to produce an instance, don't think
> > suspending or hibernating matter and couldn't fix fuse anyway?
> 
> This patch has nothing to do with suspend or hibernate.  What this
> patchset does, is help get rid of fusermount, a suid-root mount
> helper.  It also opens up new possibilities, which are not fuse
> related.
> 
> Fuse has bad interactions with the freezer, theoretically.  In
> practice, I remember just one bug report (that sparked off this whole
> "do we need freezer, or don't we" flamefest), that actually got fixed
> fairly quickly, ...maybe.  Rafael probably remembers better.

In practice, if the "unpriviledged fuse" gets enabled, any user can
prevent suspend/hibernation from working.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
