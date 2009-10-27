Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZJ0ILs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZJ0ILs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbZJ0ILr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:11:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53131 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbZJ0ILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:11:46 -0400
Date: Tue, 27 Oct 2009 09:11:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       jamie@shareable.org
Subject: Re: symlinks with permissions
Message-ID: <20091027081141.GF5019@elf.ucw.cz>
References: <20091025062953.GC1391@ucw.cz>
 <20091026163157.GB7233@duck.suse.cz>
 <20091026165729.GF23564@us.ibm.com>
 <20091026173629.GB16861@fieldses.org>
 <20091026174631.GD7233@duck.suse.cz>
 <1256579869.8576.7.camel@heimdal.trondhjem.org>
 <20091025093604.GA1501@ucw.cz>
 <1256581336.8576.20.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256581336.8576.20.camel@heimdal.trondhjem.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-10-26 14:22:16, Trond Myklebust wrote:
> On Sun, 2009-10-25 at 10:36 +0100, Pavel Machek wrote:
> > Well, it is unexpected and mild security hole.
> > 
> > Part of the problem is that even  if you have read-only
> > filedescriptor, you can upgrade it to read-write, even if path is
> > inaccessible to you.
> > 
> > So if someone passes you read-only filedescriptor, you can still write
> > to it.
> 
> If someone passes you a file descriptor, can't you in any case play
> games with, openat(fd,"",O_RDWR), in order to achieve the same thing? I
> must admit I haven't tried it yet, but at a first glance I can't see
> anything that prevents me from doing this...

According to my documentation, openat needs directory fd.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
