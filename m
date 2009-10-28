Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZJ1VG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZJ1VG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZJ1VG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:06:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39227 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZJ1VGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:06:25 -0400
Date: Wed, 28 Oct 2009 22:06:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091028210623.GB4159@elf.ucw.cz>
References: <20091025062953.GC1391@ucw.cz>
 <20091026163157.GB7233@duck.suse.cz>
 <20091026165729.GF23564@us.ibm.com>
 <20091026173629.GB16861@fieldses.org>
 <20091026174631.GD7233@duck.suse.cz>
 <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <m1zl7cb1c5.fsf@fess.ebiederm.org>
 <20091028081653.GA18290@elf.ucw.cz>
 <4AE87292.20802@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE87292.20802@schaufler-ca.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Please see bugtraq discussion at
> > http://seclists.org/bugtraq/2009/Oct/179 .
> >
> > (In short, you get read-only fd, and you can upgrade it to read-write
> > fd. Yes, you are the owner of the process, but you are not owner of
> > the file the fd refers to.)
> >
> > The actual permissions of the file are not ignored, but permissions of
> > the containing directory _are_. If there's 666 file in 700 directory,
> > you can reopen it read-write, in violation of directory's 700
> > permissions.

> 
> There is no security violation here. Consider the case where

You are able to write to my files, when unix permissions forbid
that. How do you call that? Strange behaviour of /proc/*/fd/ symlink
that is not really a symlink allows that.

See bugtraq discussion at http://seclists.org/bugtraq/2009/Oct/179 .
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
