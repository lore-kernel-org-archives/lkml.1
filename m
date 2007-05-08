Return-Path: <linux-kernel-owner+w=401wt.eu-S970321AbXEHXhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970321AbXEHXhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967388AbXEHXh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:37:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:32694 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967460AbXEHXh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TpBdH9vEl+6iR1QSNu0vsZ8OIHZoe/hdMl1Xwhn/fYw8EjrWQAo+yuNY14iNunQriPCOSp5dCep1OArpYfCdizQgn7hqJU3PgS6o3026GklZ8yMYNkKoDf7zKOKUe5EYhBatUDB++zEJ4mLopokgeL+oichkbSVEpLl1IXz11WY=
Message-ID: <a781481a0705081637x129cb009u6a557205d3776014@mail.gmail.com>
Date: Wed, 9 May 2007 05:07:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: CodingStyle: start flamewar about use of braces
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4640E971.9050400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705081903.l48J3AOw010373@hera.kernel.org>
	 <20070508124301.17975a4f.randy.dunlap@oracle.com>
	 <4640E971.9050400@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Jeff Garzik <jeff@garzik.org> wrote:
> Randy Dunlap wrote:
> > On Tue, 8 May 2007 19:03:10 GMT Linux Kernel Mailing List wrote:
> >
> >> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
> >> Commit:     e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
> >> Parent:     28be5abb400e5e082f5225105fdc69337ec0c0b4
> >> Author:     Oliver Neukum <oliver@neukum.org>
> >> AuthorDate: Tue May 8 00:30:34 2007 -0700
> >> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> >> CommitDate: Tue May 8 11:15:12 2007 -0700
> >>
> >>     CodingStyle: start flamewar about use of braces
> >
> > It worked somewhat.  We never did reach any kind of
> > concensus about this....
> >
> >
> >>     Signed-off-by: Oliver Neukum <oneukum@suse.de>
> >>     Cc: Tilman Schmidt <tilman@imap.cc>
> >>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> ---
> >>  Documentation/CodingStyle |   15 +++++++++++++++
> >>  1 files changed, 15 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> >> index 9069189..e7f5fc6 100644
> >> --- a/Documentation/CodingStyle
> >> +++ b/Documentation/CodingStyle
> >> @@ -160,6 +160,21 @@ supply of new-lines on your screen is not a renewable resource (think
> >>  25-line terminal screens here), you have more empty lines to put
> >>  comments on.
> >>
> >> +Do not unnecessarily use braces where a single statement will do.
> >> +
> >> +if (condition)
> >> +    action();
> >> +
> >> +This does not apply if one branch of a conditional statement is a single
> >> +statement. Use braces in both branches.
> >> +
> >> +if (condition) {
> >> +    do_this();
> >> +    do_that();
> >> +} else {
> >> +    otherwise();
> >> +}
>
> If anyone tries to add braces to my code's 'else' statements where they
> are not required, that patch will get NAK'd in a heartbeat.

Yes. This patch shouldn't go in. There's no ambiguity in
Documentation/CodingStyle that it fixes anyway, only *imposes* a
"style", which:

(1) there is no consensus about *at all*, and

(2) blatantly goes against _all_ similar examples in K&R.

It's quite funny to worship them as "prophets" and adopt their style
for some stuff (with a simple "Rationale: K&R.") one instant and then
suggest a style completely opposite to theirs one screenful later in
the same file.
