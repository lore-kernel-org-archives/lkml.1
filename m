Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbZJ3SgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbZJ3SgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbZJ3SgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:36:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39753 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861AbZJ3SgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:36:02 -0400
Date: Fri, 30 Oct 2009 19:35:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Jan Kara <jack@suse.cz>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091030183559.GF7008@elf.ucw.cz>
References: <20091026174631.GD7233@duck.suse.cz>
 <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <m1zl7cb1c5.fsf@fess.ebiederm.org>
 <20091028081653.GA18290@elf.ucw.cz>
 <m1k4yfkbfg.fsf@fess.ebiederm.org>
 <20091028210323.GA4159@elf.ucw.cz>
 <m1hbtj7xgj.fsf@fess.ebiederm.org>
 <20091029110344.GA1517@ucw.cz>
 <m1d4466uel.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4466uel.fsf@fess.ebiederm.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Basically, that follow link should behave as dup(), not as open().
> 
> There are reasons why an open is an open here.  I don't remember the
> details but I found the archive of that conversation once.  Maybe it was
> just technical limitations of the time.

That would be really really useful to bring 

> >> I certainly am not interested in debugging or maintaining the stacking
> >> inode code that would be necessary to close this theoretical corner
> >> case.  There are much more real bugs that need attention.
> >
> > But if we can get trivial 10-liner, that should be acceptable, right?
> 
> How many linux shell scripts and other applications that use /dev/fd/N
> or /proc/self/fd/N will you be breaking?

Zero. (Well unless someone is exploiting it in wild).

> Closing a theoretical security hole at the expense of breaking real
> applications is a show stopper.

I don't plan to remove /proc/*/fd; but I would like it to behave like
dup().

(I still hope some security team does work for me :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
