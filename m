Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbZK3M2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbZK3M2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZK3M2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:28:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34798 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZK3M2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:28:52 -0500
Date: Mon, 30 Nov 2009 13:28:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jlayton@redhat.com, jamie@shareable.org, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091130122851.GF13328@elf.ucw.cz>
References: <20091123173616.75c3f600@tlielax.poochiereds.net>
 <20091123224948.GB5598@shareable.org>
 <20091123181545.05ad004d@tlielax.poochiereds.net>
 <m1ljhwbyr3.fsf@fess.ebiederm.org>
 <20091123193426.55f1530a@tlielax.poochiereds.net>
 <20091124012027.GA14645@shareable.org>
 <20091124062621.744beddb@tlielax.poochiereds.net>
 <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu>
 <20091124120906.GA1700@ucw.cz>
 <E1NCuz4-00010e-Ch@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NCuz4-00010e-Ch@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-24 13:59:06, Miklos Szeredi wrote:
> On Tue, 24 Nov 2009, Pavel Machek wrote:
> > I believe that current semantics is ugly enough that 'documenting' it
> > is not enough... and people want to port from other systems, too, not
> > expecting nasty surprises like this...
> 
> This hasn't been a problem for the last 12 years, and still we don't
> see script kiddies exploiting this hole and sysadmins hurrying to
> secure their system, even though it has been public for quite a while.
> 
> Why?

Because condition when it hits are quite unusual?

> The reason might be, that there *is no* violation of security.

Well, security people disagree with you.

> See this: the surprise isn't that an inode can be reached from
> multiple paths, that has been possible with hard links for as long as
> unix lived.  The suprise is that the inode can be reached through
> proc.  So this "hole" that has been opened about 12 years ago in linux
> is quite well known.  Only this particular aspect of it isn't well
> known, but that doesn't mean it's not right, does it?

It does. Bypassing checks on read-only file descriptors is design
misfeature, and users are clearly unaware. (See bugtraq). Being "old"
does not mean it is right.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
