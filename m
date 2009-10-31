Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbZJaCaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbZJaCaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 22:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbZJaCaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 22:30:20 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57912 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbZJaCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 22:30:19 -0400
Date: Sat, 31 Oct 2009 02:30:10 +0000
From: Jamie Lokier <jamie@shareable.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: symlinks with permissions
Message-ID: <20091031023010.GB17680@shareable.org>
References: <20091025093604.GA1501@ucw.cz> <m1zl7cb1c5.fsf@fess.ebiederm.org> <20091028081653.GA18290@elf.ucw.cz> <m1k4yfkbfg.fsf@fess.ebiederm.org> <20091028210323.GA4159@elf.ucw.cz> <m1hbtj7xgj.fsf@fess.ebiederm.org> <20091029110344.GA1517@ucw.cz> <m1d4466uel.fsf@fess.ebiederm.org> <20091030183559.GF7008@elf.ucw.cz> <m1ocnomqlz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ocnomqlz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> >> How many linux shell scripts and other applications that use /dev/fd/N
> >> or /proc/self/fd/N will you be breaking?
> >
> > Zero. (Well unless someone is exploiting it in wild).
> 
> There are other differences like different offsets etc that may matter.
> 
> >> Closing a theoretical security hole at the expense of breaking real
> >> applications is a show stopper.
> >
> > I don't plan to remove /proc/*/fd; but I would like it to behave like
> > dup().
> >
> > (I still hope some security team does work for me :-).

Yes, it must not be like dup(), sharing the file pointer, because I'm
sure that really will break some programs.

Like all the ones using gnulib (formerly libiberty) which use
/proc/self/fd/N/path/to/file to implement fake openat(N,"path/to/file").

> I bet you will get a lot more traction and discussion if you write
> a basic mostly working version of the patch.

I agree, and I'll be happy to review/break it ;-)

-- Jamie
