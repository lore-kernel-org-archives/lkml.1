Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZK3TAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZK3TAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZK3TAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:00:45 -0500
Received: from mail2.shareable.org ([80.68.89.115]:59077 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZK3TAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:00:45 -0500
Date: Mon, 30 Nov 2009 19:00:30 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Duane Griffin <duaneg@dghda.com>
Cc: Pavel Machek <pavel@ucw.cz>, Miklos Szeredi <miklos@szeredi.hu>,
       Jeff Layton <jlayton@redhat.com>, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
Message-ID: <20091130190030.GA5560@shareable.org>
References: <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <m1ljhwbyr3.fsf@fess.ebiederm.org> <20091123193426.55f1530a@tlielax.poochiereds.net> <20091124012027.GA14645@shareable.org> <20091124062621.744beddb@tlielax.poochiereds.net> <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu> <20091124120906.GA1700@ucw.cz> <e9e943910911240513g31e633ffg2e878a874f1110ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e943910911240513g31e633ffg2e878a874f1110ba@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duane Griffin wrote:
> 2009/11/24 Pavel Machek <pavel@ucw.cz>:
> > On Tue 2009-11-24 12:53:09, Miklos Szeredi wrote:
> >> I still believe leaving the current semantics and documenting them is
> >> the best option.
> >
> > I believe that current semantics is ugly enough that 'documenting' it
> > is not enough... and people want to port from other systems, too, not
> > expecting nasty surprises like this...
> 
> Solaris 10 works the same way as Linux does now, so I don't think the
> porting argument gets you anywhere.

It certainly must be similar, as gnulib uses the same technique on
both Solaris and Linux.

I don't have a Solaris to try this on.  Can you use /proc to re-open
with O_RDWR a file descriptor previously opened with O_RDONLY on
Solaris 10, assuming the underlying inode allows writing?

-- Jamie
