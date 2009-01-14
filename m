Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZANNgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZANNgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZANNf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:35:57 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39122 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbZANNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:35:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IH+xNhoRorbTaCljxlJ+AVi/qs9gwqFvECINKc9pa2hOSJXDlKNDPl8i3Al/7nGaDp
         5wlBGcOLV2Ah7t3T5SDZ7tuvj7yS5e9/u1HkPucgPQY7I+koc/tmwgEtNgygnDK8nTJH
         Sd3IYUjUUw3wGEWFw/44mElwHRvRdzOKa0bq8=
Message-ID: <c62985530901140535m5ce716d4t648a5f44dcbad38c@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:35:53 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 08/10] MAINTAINERS - Add FTRACE git
Cc: "Joe Perches" <joe@perches.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0901140811530.6759@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <1231878498-25171-9-git-send-email-joe@perches.com>
	 <20090114055954.GA7039@linux-sh.org>
	 <1231913987.30095.11.camel@localhost>
	 <alpine.DEB.1.10.0901140811530.6759@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/14 Steven Rostedt <rostedt@goodmis.org>:
>
> On Tue, 13 Jan 2009, Joe Perches wrote:
>
>> On Wed, 2009-01-14 at 14:59 +0900, Paul Mundt wrote:
>> > On Tue, Jan 13, 2009 at 12:28:16PM -0800, Joe Perches wrote:
>> > > Signed-off-by: Joe Perches <joe@perches.com>
>> > > ---
>> > >  MAINTAINERS |    1 +
>> > >  1 files changed, 1 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/MAINTAINERS b/MAINTAINERS
>> > > index ceeeb8c..6e051c3 100644
>> > > --- a/MAINTAINERS
>> > > +++ b/MAINTAINERS
>> > > @@ -2189,6 +2189,7 @@ F:  fs/freevxfs/
>> > >  FTRACE
>> > >  P:       Steven Rostedt
>> > >  M:       rostedt@goodmis.org
>> > > +T:       git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
>> > >  S:       Maintained
>> > >  F:       Documentation/ftrace.txt
>> > >  F:       arch/*/*/*/ftrace.h
>> >
>> > This sort of thing only makes sense if you include the topic branch for
>> > the tree in question. While it is true that ftrace development happens in
>> > this tree, people looking at ftrace may not want to sort through the
>> > hundreds of unrelated topic branches in the process. I say this as
>> > someone that does not want to sort through hundreds of unrelated topic
>> > branches in search of ftrace code ;-)
>>
>> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=heads
>>
>> Is the correct topic branch for ftrace auto-ftrace-next?
>
> That is just a location that Ingo places changes that are ready to go to
> linux-next. Not where development is.
>
>>
>> maybe:
>>
>> T:    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git auto-ftrace-next
>>
>> No idea what's right here.  I had some private emails
>> with Steven Rostedt about a git tree.  He suggested
>> to use tip.
>>
>> Steven?  Suggestions?
>
> Ingo usually pulls ftrace related patches into the tracing/ftrace
> branch. That is for core ftrace. Since ftrace has a bunch of pluggins,
> they may have their own branches.
>
> But to answer Paul's question, I would suggest tracing/ftrace for
> seeing latest core ftrace changes.


But most of the time, all of these tracing/* topics are quickly merged
into tip/master.
Sometimes they are not because of a pending breakage but tip/master is
rarely more than a tiny bit out of sync against
tracing/ topics.
I guess tip/master is enough and good to base a work on, or to see the
latest changes in tracing.
No?


> Should we add another topic in MAINTAINERS? The "TRACE RING BUFFER"? or
> just call it ring_buffer? This is separate from ftrace, although ftrace
> uses it for on the fly tracing. I maintain it and it is located in the tip
> git repo under tracing/ring-buffer.
>
> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
